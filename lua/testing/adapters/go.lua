-- Go Test Adapter Implementation
-- Handles Go-specific test discovery, execution, and parsing

local TestAdapter = require("testing.adapter")

local GoTestAdapter = TestAdapter:new({
  name = "go",
  file_patterns = { "go", "%.go$" },
  test_command = "go test",
  supports_nearest = true,
  supports_file = true,
  supports_all = true,
})

function GoTestAdapter:is_test_file(filepath)
  return filepath:match("_test%.go$") ~= nil
end

function GoTestAdapter:find_test_functions(bufnr)
  local test_functions = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr or 0, 0, -1, false)

  for line_num, line in ipairs(lines) do
    local test_name = line:match("func%s+%(.*%)%s+(Test[%w_]+)") or line:match("func%s+(Test[%w_]+)")
    if test_name then
      test_functions[test_name] = line_num
    end
  end

  return test_functions
end

function GoTestAdapter:get_test_name_at_cursor(bufnr, cursor_line)
  local lines = vim.api.nvim_buf_get_lines(bufnr or 0, 0, -1, false)
  local test_name = nil
  local test_function_line = nil

  -- Look backwards from cursor to find the test function
  for i = cursor_line, 1, -1 do
    local line = lines[i]
    if line then
      local match = line:match("func%s+%(.*%)%s+(Test[%w_]+)") or line:match("func%s+(Test[%w_]+)")
      if match then
        test_name = match
        test_function_line = i
        break
      end
    end
  end

  if not test_name then
    return nil
  end

  -- Check if this is a table-driven test
  local is_table_driven = false
  local max_lines_to_check = math.min(50, #lines - test_function_line)

  for i = test_function_line, test_function_line + max_lines_to_check do
    local line = lines[i]
    if
      line
      and (
        line:match("for%s+[%w_,%-]*%s*:=%s*range%s+.*struct")
        or line:match("for%s+[%w_,%-]*%s*:=%s*range%s+tests")
        or line:match("for%s+[%w_,%-]*%s*:=%s*range%s+.*cases")
        or line:match("for%s+[%w_,%-]*%s*:=%s*range%s+%[%]struct")
        or line:match("tests%s*:=%s*%[%]struct")
        or line:match("cases%s*:=%s*%[%]struct")
      )
    then
      is_table_driven = true
      break
    end
  end

  return {
    name = test_name,
    line = test_function_line,
    is_table_driven = is_table_driven,
  }
end

function GoTestAdapter:build_test_command(test_type, context)
  local package_path = self:get_relative_package_path()

  if test_type == "nearest" and context.test_info then
    local test_pattern = context.test_info.name
    if context.test_info.is_table_driven then
      test_pattern = string.format("^%s$", context.test_info.name)
    end
    return string.format('cd "%s" && go test -v %s -run "%s"', vim.fn.getcwd(), package_path, test_pattern)
  elseif test_type == "file" then
    return string.format('cd "%s" && go test -v %s', vim.fn.getcwd(), package_path)
  elseif test_type == "all" then
    return "go test -v ./..."
  end

  return nil
end

function GoTestAdapter:get_relative_package_path()
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.fnamemodify(current_file, ":h")

  -- Try to get go.mod directory
  local handle = io.popen(string.format('cd "%s" && go env GOMOD 2>/dev/null', current_dir))
  if handle then
    local gomod_path = handle:read("*l")
    handle:close()

    if gomod_path and gomod_path ~= "" and gomod_path ~= "<nil>" then
      local gomod_dir = vim.fn.fnamemodify(gomod_path, ":h")
      local rel_path = current_dir:gsub("^" .. vim.pesc(gomod_dir) .. "/?", "")
      return rel_path == "" and "." or "./" .. rel_path
    end
  end

  return "."
end

function GoTestAdapter:parse_test_output(output)
  local results = {}
  local current_test = nil
  local lines = vim.split(output, "\n")
  local global_output = {} -- Capture all output for failed tests

  for _, line in ipairs(lines) do
    -- Always capture the line for potential use
    table.insert(global_output, line)

    -- Match test start: === RUN   TestName or === RUN   TestName/subtest
    local test_name = line:match("=== RUN%s+(%S+)")
    if test_name then
      -- For subtests (TestName/subtest), we want to track the parent test
      local parent_test = test_name:match("^([^/]+)")
      if parent_test then
        test_name = parent_test -- Use parent test name for table-driven tests
      end

      if not results[test_name] then
        results[test_name] = {
          name = test_name,
          status = "running",
          output = {},
          subtests = {},
          duration = nil,
          raw_output = {},
        }
      end
      current_test = results[test_name]
    end

    -- Match test result: --- PASS: TestName (0.00s) or --- FAIL: TestName (0.00s)
    local status, name, duration = line:match("--- (%w+): (%S+) %(([^)]+)%)")
    if status and name then
      local parent_test = name:match("^([^/]+)")
      if parent_test and results[parent_test] then
        -- This is a subtest result
        if not results[parent_test].subtests then
          results[parent_test].subtests = {}
        end
        table.insert(results[parent_test].subtests, {
          name = name,
          status = status:lower(),
          duration = duration,
        })

        -- Update parent test status - if any subtest fails, parent fails
        if status:lower() == "fail" then
          results[parent_test].status = "fail"
        elseif results[parent_test].status ~= "fail" and status:lower() == "pass" then
          results[parent_test].status = "pass"
        end
        results[parent_test].duration = duration -- Use last duration as overall
      else
        -- This is a main test result
        if results[name] then
          results[name].status = status:lower()
          results[name].duration = duration
        end
      end
    end

    -- Capture all output lines for the current test (much more inclusive)
    if current_test then
      table.insert(current_test.output, line)
      table.insert(current_test.raw_output, line)
    end

    -- Special handling for test failures and logs
    if
      line:match("FAIL:")
      or line:match("panic:")
      or line:match("Error:")
      or line:match("t%.Log")
      or line:match("t%.Error")
      or line:match("t%.Fatal")
    then
      if current_test then
        -- Mark this as important output
        table.insert(current_test.output, "🚨 " .. line)
      end
    end
  end

  -- Post-process to add full context for failed tests
  for test_name, result in pairs(results) do
    if result.status == "fail" and #result.output == 0 then
      -- If no specific output captured, provide the global context
      result.output = global_output
    end
  end

  return results
end

return GoTestAdapter
