-- Test UI Components
-- Handles signs, popups, and visual feedback

local UI = {}

-- Initialize global storage
if not _G.test_results then
  _G.test_results = {}
end

-- Test sign management
function UI.setup_test_signs()
  -- Define custom signs for test status with wider characters
  vim.fn.sign_define("test_pass", {
    text = "▌", -- Wider block character for better visibility
    texthl = "TestPassSign",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("test_fail", {
    text = "▌", -- Wider block character
    texthl = "TestFailSign",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("test_running", {
    text = "▌", -- Wider block character
    texthl = "TestRunningSign",
    linehl = "",
    numhl = "",
  })

  -- Define highlight groups for test signs with better color visibility
  -- Use autocmd to ensure highlights are applied after colorscheme loads
  local function setup_test_highlights()
    vim.cmd([[
      highlight TestPassSign guifg=#50fa7b gui=bold ctermfg=green
      highlight TestFailSign guifg=#ff5555 gui=bold ctermfg=red
      highlight TestRunningSign guifg=#f1fa8c gui=bold ctermfg=yellow
    ]])
  end

  -- Apply highlights immediately
  setup_test_highlights()

  -- Reapply highlights when colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = setup_test_highlights,
    desc = "Reapply test sign highlights after colorscheme change",
  })
end

function UI.clear_test_signs()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace("test_signs", { buffer = bufnr })
end

function UI.mark_test_function(test_name, status, start_line, end_line)
  local bufnr = vim.api.nvim_get_current_buf()
  local sign_name = string.format("test_%s", status)

  -- If end_line not provided, use a simple heuristic
  if not end_line then
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, -1, false)
    end_line = start_line + 30 -- Default span of 30 lines

    -- Look for the next function or end of buffer
    for i = 2, math.min(100, #lines) do
      local line = lines[i]
      if line and line:match("func%s+") then
        end_line = start_line + i - 2
        break
      end
    end
  end

  -- Place signs on multiple lines to create a "thick line" effect
  for line = start_line, math.min(end_line, start_line + 50) do -- Limit to 50 lines max
    vim.fn.sign_place(0, "test_signs", sign_name, bufnr, { lnum = line })
  end
end

function UI.update_test_signs(test_results, test_functions)
  -- Clear existing signs
  UI.clear_test_signs()

  -- Place new signs
  for test_name, result in pairs(test_results) do
    local line_num = test_functions[test_name]
    if line_num then
      UI.mark_test_function(test_name, result.status, line_num)
    end
  end
end

-- Popup window for displaying test output
function UI.create_popup(content, title, width, height)
  local buf = vim.api.nvim_create_buf(false, true)
  local win_width = math.floor(vim.o.columns * (width or 0.8))
  local win_height = math.floor(vim.o.lines * (height or 0.8))

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    col = (vim.o.columns - win_width) / 2,
    row = (vim.o.lines - win_height) / 2,
    style = "minimal",
    border = "rounded",
    title = title or "Test Output",
    title_pos = "center",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set content
  if type(content) == "table" then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
  end

  -- Make buffer read-only
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "readonly", true)

  -- Set syntax highlighting for test output
  vim.api.nvim_buf_set_option(buf, "filetype", "test-output")

  -- Close on q or Escape
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })

  return buf, win
end

-- Status message formatting
function UI.format_test_status(test_results)
  local passed_count = 0
  local failed_count = 0
  local subtest_passed = 0
  local subtest_failed = 0

  for test_name, result in pairs(test_results) do
    if result.status == "pass" then
      passed_count = passed_count + 1
    elseif result.status == "fail" then
      failed_count = failed_count + 1
    end

    -- Count subtests if they exist
    if result.subtests then
      for _, subtest in ipairs(result.subtests) do
        if subtest.status == "pass" then
          subtest_passed = subtest_passed + 1
        else
          subtest_failed = subtest_failed + 1
        end
      end
    end
  end

  -- Brief status notification
  local status_msg = ""
  if failed_count > 0 then
    status_msg = string.format("❌ %d failed, %d passed", failed_count, passed_count)
    if subtest_failed > 0 then
      status_msg = status_msg .. string.format(" (%d subtests failed)", subtest_failed)
    end
  else
    status_msg = string.format("✅ All %d tests passed", passed_count)
    if subtest_passed > 0 then
      status_msg = status_msg .. string.format(" (%d subtests)", subtest_passed)
    end
  end

  return status_msg
end

-- Setup syntax highlighting for test output
function UI.setup_test_syntax()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "test-output",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()

      -- Define syntax highlighting
      vim.cmd([[
        syntax match TestPass /✅.*$/
        syntax match TestFail /❌.*$/
        syntax match TestRunning /⏳.*$/
        syntax match TestAlert /🚨.*$/

        highlight TestPass guifg=#50fa7b gui=bold
        highlight TestFail guifg=#ff5555 gui=bold  
        highlight TestRunning guifg=#f1fa8c gui=bold
        highlight TestAlert guifg=#ff5555 gui=bold
      ]])
    end,
  })
end

return UI

