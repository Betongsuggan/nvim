{ ... }: {
  plugins = {
    # Test runner - disable auto-setup, we'll do it manually
    neotest = {
      enable = true;
      # No auto adapters - we'll configure manually in extraConfigLua
      # to avoid compatibility issues
    };

    # Go debug adapter
    dap-go = {
      enable = true;
    };

    # Debug Adapter Protocol (DAP)
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "◯";
          texthl = "DapBreakpoint";
        };
        dapBreakpointRejected = {
          text = "✖";
          texthl = "DapBreakpoint";
        };
        dapLogPoint = {
          text = "◉";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "→";
          texthl = "DapStopped";
        };
      };
    };

    # DAP UI
    dap-ui = {
      enable = true;
    };

    # DAP Virtual Text
    dap-virtual-text = {
      enable = true;
    };
  };

  # Basic test keymaps
  keymaps = [
    # Universal test running - works with any supported language via adapters
    {
      mode = "n";
      key = "<leader>tt";
      action = {
        __raw = ''
          function() 
            -- Use universal test runner
            run_test_nearest()
          end
        '';
      };
      options = {
        desc = "Run nearest test";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = {
        __raw = ''
          function() 
            -- Use universal test runner
            run_test_file()
          end
        '';
      };
      options = {
        desc = "Run tests in current file";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ta";
      action = {
        __raw = ''
          function() 
            -- Use universal test runner
            run_test_all()
          end
        '';
      };
      options = {
        desc = "Run all tests";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ti";
      action = ":lua check_neotest()<CR>";
      options = {
        desc = "Test info";
        silent = false;
      };
    }
    # New beautiful test UI keymaps
    {
      mode = "n";
      key = "<leader>to";
      action = ":lua show_test_results_telescope()<CR>";
      options = {
        desc = "Open test results in telescope";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = ":lua show_raw_test_output()<CR>";
      options = {
        desc = "Show raw test output";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = ":lua clear_go_test_signs()<CR>";
      options = {
        desc = "Clear test signs from gutter";
        silent = true;
      };
    }
    
    # Debug keymaps
    {
      mode = "n";
      key = "<leader>db";
      action = ":lua require('dap').toggle_breakpoint()<CR>";
      options = {
        desc = "Toggle breakpoint";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = ":lua require('dap').continue()<CR>";
      options = {
        desc = "Continue debugging";
        silent = true;
      };
    }
  ];

  # Modular test runner configuration supporting multiple languages
  extraConfigLua = ''
    -- Modular Test Runner System
    -- Supports multiple languages through adapter pattern
    _G.test_results = {} -- Global test results storage
    _G.test_adapters = {} -- Registry of language adapters
    
    -- Define custom signs for test status with wider characters
    vim.fn.sign_define("test_pass", {
      text = "▌",  -- Wider block character for better visibility
      texthl = "TestPassSign",
      linehl = "",
      numhl = ""
    })
    
    vim.fn.sign_define("test_fail", {
      text = "▌",  -- Wider block character
      texthl = "TestFailSign", 
      linehl = "",
      numhl = ""
    })
    
    vim.fn.sign_define("test_running", {
      text = "▌",  -- Wider block character
      texthl = "TestRunningSign",
      linehl = "",
      numhl = ""
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
      desc = "Reapply test sign highlights after colorscheme change"
    })

    -- ========================================
    -- MODULAR TEST ADAPTER SYSTEM
    -- ========================================
    
    -- Base Test Adapter Interface
    -- Each language adapter should implement these methods:
    local TestAdapter = {}
    TestAdapter.__index = TestAdapter
    
    function TestAdapter:new(config)
      local adapter = {
        name = config.name or "unknown",
        file_patterns = config.file_patterns or {},
        test_command = config.test_command or "",
        supports_nearest = config.supports_nearest or false,
        supports_file = config.supports_file or false,
        supports_all = config.supports_all or false,
      }
      setmetatable(adapter, TestAdapter)
      return adapter
    end
    
    -- Interface methods that must be implemented by language adapters
    function TestAdapter:is_test_file(filepath)
      error("is_test_file must be implemented by language adapter")
    end
    
    function TestAdapter:find_test_functions(bufnr)
      error("find_test_functions must be implemented by language adapter")
    end
    
    function TestAdapter:build_test_command(test_type, context)
      error("build_test_command must be implemented by language adapter")
    end
    
    function TestAdapter:parse_test_output(output)
      error("parse_test_output must be implemented by language adapter")
    end
    
    function TestAdapter:get_test_name_at_cursor(bufnr, cursor_line)
      error("get_test_name_at_cursor must be implemented by language adapter")
    end
    
    -- Test Adapter Registry
    local TestAdapterRegistry = {}
    
    function TestAdapterRegistry.register(adapter)
      if not adapter.name then
        error("Adapter must have a name")
      end
      _G.test_adapters[adapter.name] = adapter
      print("✓ Registered test adapter: " .. adapter.name)
    end
    
    function TestAdapterRegistry.get_adapter_for_file(filepath)
      local filetype = vim.filetype.match({ filename = filepath }) or ""
      local extension = filepath:match("%.([^%.]+)$") or ""
      
      for _, adapter in pairs(_G.test_adapters) do
        if adapter:is_test_file(filepath) then
          return adapter
        end
      end
      
      -- Fallback: try to match by filetype or extension
      for _, adapter in pairs(_G.test_adapters) do
        for _, pattern in ipairs(adapter.file_patterns) do
          if filetype:match(pattern) or extension:match(pattern) then
            return adapter
          end
        end
      end
      
      return nil
    end
    
    function TestAdapterRegistry.list_adapters()
      local adapters = {}
      for name, adapter in pairs(_G.test_adapters) do
        table.insert(adapters, {
          name = name,
          file_patterns = adapter.file_patterns,
          supports_nearest = adapter.supports_nearest,
          supports_file = adapter.supports_file,
          supports_all = adapter.supports_all
        })
      end
      return adapters
    end
    
    -- ========================================
    -- GO TEST ADAPTER IMPLEMENTATION
    -- ========================================
    
    local GoTestAdapter = TestAdapter:new({
      name = "go",
      file_patterns = {"go", "%.go$"},
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
        local test_name = line:match('func%s+%(.*%)%s+(Test%w+)') or line:match('func%s+(Test%w+)')
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
          local match = line:match('func%s+%(.*%)%s+(Test%w+)') or line:match('func%s+(Test%w+)')
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
        if line and (
          line:match('for%s+[%w_,%-]*%s*:=%s*range%s+.*struct') or
          line:match('for%s+[%w_,%-]*%s*:=%s*range%s+tests') or
          line:match('for%s+[%w_,%-]*%s*:=%s*range%s+.*cases') or
          line:match('for%s+[%w_,%-]*%s*:=%s*range%s+%[%]struct') or
          line:match('tests%s*:=%s*%[%]struct') or
          line:match('cases%s*:=%s*%[%]struct')
        ) then
          is_table_driven = true
          break
        end
      end
      
      return {
        name = test_name,
        line = test_function_line,
        is_table_driven = is_table_driven
      }
    end
    
    function GoTestAdapter:build_test_command(test_type, context)
      local package_path = self:get_relative_package_path()
      
      if test_type == "nearest" and context.test_info then
        local test_pattern = context.test_info.name
        if context.test_info.is_table_driven then
          test_pattern = string.format("^%s$", context.test_info.name)
        end
        return string.format('cd "%s" && go test -v %s -run "%s"', 
          vim.fn.getcwd(), package_path, test_pattern)
      elseif test_type == "file" then
        return string.format('cd "%s" && go test -v %s', vim.fn.getcwd(), package_path)
      elseif test_type == "all" then
        return 'go test -v ./...'
      end
      
      return nil
    end
    
    function GoTestAdapter:get_relative_package_path()
      local current_file = vim.fn.expand('%:p')
      local current_dir = vim.fn.fnamemodify(current_file, ':h')
      
      -- Try to get go.mod directory
      local handle = io.popen(string.format('cd "%s" && go env GOMOD 2>/dev/null', current_dir))
      if handle then
        local gomod_path = handle:read('*l')
        handle:close()
        
        if gomod_path and gomod_path ~= "" and gomod_path ~= "<nil>" then
          local gomod_dir = vim.fn.fnamemodify(gomod_path, ':h')
          local rel_path = current_dir:gsub("^" .. vim.pesc(gomod_dir) .. "/?", "")
          return rel_path == "" and "." or "./" .. rel_path
        end
      end
      
      return "."
    end
    
    function GoTestAdapter:parse_test_output(output)
      local results = {}
      local current_test = nil
      local lines = vim.split(output, '\n')
      local global_output = {} -- Capture all output for failed tests
      
      for _, line in ipairs(lines) do
        -- Always capture the line for potential use
        table.insert(global_output, line)
        
        -- Match test start: === RUN   TestName or === RUN   TestName/subtest
        local test_name = line:match('=== RUN%s+(%S+)')
        if test_name then
          -- For subtests (TestName/subtest), we want to track the parent test
          local parent_test = test_name:match('^([^/]+)')
          if parent_test then
            test_name = parent_test -- Use parent test name for table-driven tests
          end
          
          if not results[test_name] then
            results[test_name] = {
              name = test_name,
              status = 'running',
              output = {},
              subtests = {},
              duration = nil,
              raw_output = {}
            }
          end
          current_test = results[test_name]
        end
        
        -- Match test result: --- PASS: TestName (0.00s) or --- FAIL: TestName (0.00s)
        local status, name, duration = line:match('--- (%w+): (%S+) %(([^)]+)%)')
        if status and name then
          local parent_test = name:match('^([^/]+)')
          if parent_test and results[parent_test] then
            -- This is a subtest result
            if not results[parent_test].subtests then
              results[parent_test].subtests = {}
            end
            table.insert(results[parent_test].subtests, {
              name = name,
              status = status:lower(),
              duration = duration
            })
            
            -- Update parent test status - if any subtest fails, parent fails
            if status:lower() == 'fail' then
              results[parent_test].status = 'fail'
            elseif results[parent_test].status ~= 'fail' and status:lower() == 'pass' then
              results[parent_test].status = 'pass'
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
        if line:match('FAIL:') or line:match('panic:') or line:match('Error:') or 
           line:match('t%.Log') or line:match('t%.Error') or line:match('t%.Fatal') then
          if current_test then
            -- Mark this as important output
            table.insert(current_test.output, "🚨 " .. line)
          end
        end
      end
      
      -- Post-process to add full context for failed tests
      for test_name, result in pairs(results) do
        if result.status == 'fail' and #result.output == 0 then
          -- If no specific output captured, provide the global context
          result.output = global_output
        end
      end
      
      return results
    end
    
    -- Register the Go adapter
    TestAdapterRegistry.register(GoTestAdapter)

    -- Function to clear all test signs in current buffer
    local function clear_test_signs()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.fn.sign_unplace("test_signs", { buffer = bufnr })
    end
    
    -- ========================================
    -- UNIVERSAL TEST RUNNER UI
    -- ========================================
    
    -- Universal function to find test functions using the appropriate adapter
    local function find_test_functions()
      local filepath = vim.fn.expand('%:p')
      local adapter = TestAdapterRegistry.get_adapter_for_file(filepath)
      
      if not adapter then
        return {}
      end
      
      local bufnr = vim.api.nvim_get_current_buf()
      return adapter:find_test_functions(bufnr)
    end
    
    -- Function to mark test function with signs across multiple lines
    local function mark_test_function(test_name, status, start_line, end_line)
      local bufnr = vim.api.nvim_get_current_buf()
      local sign_name = string.format("test_%s", status)
      
      -- If end_line not provided, use a simple heuristic
      if not end_line then
        local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, -1, false)
        end_line = start_line + 30 -- Default span of 30 lines
        
        -- Look for the next function or end of buffer
        for i = 2, math.min(100, #lines) do
          local line = lines[i]
          if line and line:match('func%s+') then
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
    
    -- Function to update test signs based on results
    local function update_test_signs(test_results)
      local test_functions = find_test_functions()
      
      -- Clear existing signs
      clear_test_signs()
      
      -- Place new signs
      for test_name, result in pairs(test_results) do
        local line_num = test_functions[test_name]
        if line_num then
          mark_test_function(test_name, result.status, line_num)
        end
      end
    end

    -- Function to create a beautiful popup window
    local function create_popup(content, title, width, height)
      local buf = vim.api.nvim_create_buf(false, true)
      local win_width = math.floor(vim.o.columns * (width or 0.8))
      local win_height = math.floor(vim.o.lines * (height or 0.8))
      
      local opts = {
        relative = 'editor',
        width = win_width,
        height = win_height,
        col = (vim.o.columns - win_width) / 2,
        row = (vim.o.lines - win_height) / 2,
        style = 'minimal',
        border = 'rounded',
        title = title or 'Test Output',
        title_pos = 'center'
      }
      
      local win = vim.api.nvim_open_win(buf, true, opts)
      
      -- Set content
      if type(content) == 'table' then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
      else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, '\n'))
      end
      
      -- Make buffer read-only
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
      vim.api.nvim_buf_set_option(buf, 'readonly', true)
      
      -- Set syntax highlighting for Go test output
      vim.api.nvim_buf_set_option(buf, 'filetype', 'go-test-output')
      
      -- Close on q or Escape
      vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
      vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
      
      return buf, win
    end
    
    -- Universal test runner function
    local function run_test_with_ui(test_type, context)
      local filepath = vim.fn.expand('%:p')
      local adapter = TestAdapterRegistry.get_adapter_for_file(filepath)
      
      if not adapter then
        local filetype = vim.filetype.match({ filename = filepath }) or "unknown"
        print(string.format("❌ No test adapter found for %s files", filetype))
        print("Available adapters: " .. table.concat(vim.tbl_keys(_G.test_adapters), ", "))
        return
      end
      
      -- Build the test command using the adapter
      local cmd = adapter:build_test_command(test_type, context or {})
      if not cmd then
        print("❌ Failed to build test command")
        return
      end
      
      -- Mark all found tests as running
      local test_functions = find_test_functions()
      clear_test_signs()
      for test_name, line_num in pairs(test_functions) do
        mark_test_function(test_name, "running", line_num)
      end
      
      -- Show loading notification
      local loading_msg = string.format("🧪 Running %s tests using %s adapter...", test_type, adapter.name)
      print(loading_msg)
      
      -- Run command and capture output
      local handle = io.popen(cmd .. ' 2>&1')
      if not handle then
        print("❌ Failed to run test command")
        return
      end
      
      local output = handle:read('*a')
      handle:close()
      
      -- Parse results using the adapter
      local parsed_results = adapter:parse_test_output(output)
      _G.test_results = parsed_results
      
      -- Update gutter signs based on results
      update_test_signs(parsed_results)
      
      -- Show brief status message
      local passed_count = 0
      local failed_count = 0
      local subtest_passed = 0
      local subtest_failed = 0
      
      for test_name, result in pairs(parsed_results) do
        if result.status == 'pass' then
          passed_count = passed_count + 1
        elseif result.status == 'fail' then
          failed_count = failed_count + 1
        end
        
        -- Count subtests if they exist
        if result.subtests then
          for _, subtest in ipairs(result.subtests) do
            if subtest.status == 'pass' then
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
      
      print(string.format("%s - Press <leader>to for details", status_msg))
      
      -- Store raw output for debugging
      _G.test_raw_output = output
    end

    -- Legacy Go-specific parse function (will be removed)
    local function parse_test_output(output)
      local results = {}
      local current_test = nil
      local lines = vim.split(output, '\n')
      local global_output = {} -- Capture all output for failed tests
      
      for _, line in ipairs(lines) do
        -- Always capture the line for potential use
        table.insert(global_output, line)
        
        -- Match test start: === RUN   TestName or === RUN   TestName/subtest
        local test_name = line:match('=== RUN%s+(%S+)')
        if test_name then
          -- For subtests (TestName/subtest), we want to track the parent test
          local parent_test = test_name:match('^([^/]+)')
          if parent_test then
            test_name = parent_test -- Use parent test name for table-driven tests
          end
          
          if not results[test_name] then
            results[test_name] = {
              name = test_name,
              status = 'running',
              output = {},
              subtests = {},
              duration = nil,
              raw_output = {}
            }
          end
          current_test = results[test_name]
        end
        
        -- Match test result: --- PASS: TestName (0.00s) or --- FAIL: TestName (0.00s)
        local status, name, duration = line:match('--- (%w+): (%S+) %(([^)]+)%)')
        if status and name then
          local parent_test = name:match('^([^/]+)')
          if parent_test and results[parent_test] then
            -- This is a subtest result
            if not results[parent_test].subtests then
              results[parent_test].subtests = {}
            end
            table.insert(results[parent_test].subtests, {
              name = name,
              status = status:lower(),
              duration = duration
            })
            
            -- Update parent test status - if any subtest fails, parent fails
            if status:lower() == 'fail' then
              results[parent_test].status = 'fail'
            elseif results[parent_test].status ~= 'fail' and status:lower() == 'pass' then
              results[parent_test].status = 'pass'
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
        if line:match('FAIL:') or line:match('panic:') or line:match('Error:') or 
           line:match('t%.Log') or line:match('t%.Error') or line:match('t%.Fatal') then
          if current_test then
            -- Mark this as important output
            table.insert(current_test.output, "🚨 " .. line)
          end
        end
      end
      
      -- Post-process to add full context for failed tests
      for test_name, result in pairs(results) do
        if result.status == 'fail' then
          -- Add more context around failure
          result.full_context = {}
          local in_test_context = false
          for _, line in ipairs(global_output) do
            if line:match('=== RUN%s+' .. test_name) then
              in_test_context = true
            elseif line:match('=== RUN%s+') and not line:match(test_name) then
              in_test_context = false
            end
            
            if in_test_context then
              table.insert(result.full_context, line)
            end
          end
        end
      end
      
      return results
    end
    
    -- Function to run Go test with subtle gutter indication
    local function run_go_test_with_ui(cmd, test_type)
      -- Show running status in gutter first
      local test_functions = find_test_functions()
      
      -- Mark all found tests as running
      clear_test_signs()
      for test_name, line_num in pairs(test_functions) do
        mark_test_function(test_name, "running", line_num)
      end
      
      -- Show subtle loading notification
      local loading_msg = string.format("🧪 Running %s...", test_type)
      print(loading_msg)
      
      -- Run command and capture output
      local handle = io.popen(cmd .. ' 2>&1')
      if not handle then
        print("❌ Failed to run test command")
        return
      end
      
      local output = handle:read('*a')
      handle:close()
      
      -- Parse results
      local parsed_results = parse_test_output(output)
      _G.go_test_results = parsed_results
      
      -- Update gutter signs based on results
      update_test_signs(parsed_results)
      
      -- Show brief status message
      local passed_count = 0
      local failed_count = 0
      local subtest_passed = 0
      local subtest_failed = 0
      
      for test_name, result in pairs(parsed_results) do
        if result.status == 'pass' then
          passed_count = passed_count + 1
        elseif result.status == 'fail' then
          failed_count = failed_count + 1
        end
        
        -- Count subtests
        if result.subtests then
          for _, subtest in ipairs(result.subtests) do
            if subtest.status == 'pass' then
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
      
      print(string.format("%s - Press <leader>to for details", status_msg))
      
      -- Store raw output for viewing
      _G.go_test_raw_output = output
    end
    
    -- ========================================
    -- UNIVERSAL GLOBAL TEST FUNCTIONS
    -- ========================================
    
    -- Universal function to show test results in telescope
    function _G.show_test_results_telescope()
      if not _G.test_results or vim.tbl_isempty(_G.test_results) then
        print("No test results available. Run tests first.")
        return
      end
      
      local pickers = require "telescope.pickers"
      local finders = require "telescope.finders"
      local conf = require("telescope.config").values
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"
      
      local results = {}
      for test_name, result in pairs(_G.test_results) do
        local status_icon = result.status == 'pass' and '✅' or result.status == 'fail' and '❌' or '⏳'
        local duration_text = result.duration and (string.format(' (%s)', result.duration)) or ""
        local display_text = string.format('%s %s%s', status_icon, test_name, duration_text)
        table.insert(results, {
          display = display_text,
          name = test_name,
          result = result
        })
      end
      
      pickers.new({}, {
        prompt_title = "🧪 Go Test Results",
        finder = finders.new_table {
          results = results,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.display,
              ordinal = entry.name,
            }
          end,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              local result = selection.value.result
              local test_title = string.format("🧪 Test: %s", selection.value.name)
              local content = { test_title, "" }
              
              if result.status then
                local status_line = string.format("📊 Status: %s", result.status:upper())
                if result.duration then
                  status_line = string.format("%s (%s)", status_line, result.duration)
                end
                table.insert(content, status_line)
                table.insert(content, "")
              end
              
              -- Show subtests if available
              if result.subtests and #result.subtests > 0 then
                table.insert(content, "🔍 Subtests:")
                for _, subtest in ipairs(result.subtests) do
                  local subtest_icon = subtest.status == 'pass' and '✅' or '❌'
                  local subtest_line = string.format("  %s %s (%s)", subtest_icon, subtest.name, subtest.duration or "N/A")
                  table.insert(content, subtest_line)
                end
                table.insert(content, "")
              end
              
              -- Show output with better formatting
              if result.status == 'fail' and result.full_context and #result.full_context > 0 then
                table.insert(content, "🔥 Full Failure Context:")
                table.insert(content, "")
                for _, line in ipairs(result.full_context) do
                  -- Highlight important lines
                  if line:match('FAIL:') or line:match('Error:') or line:match('panic:') then
                    table.insert(content, "❗ " .. line)
                  elseif line:match('expected') or line:match('actual') or line:match('got:') or line:match('want:') then
                    table.insert(content, "⚡ " .. line)
                  else
                    table.insert(content, line)
                  end
                end
              elseif #result.output > 0 then
                table.insert(content, "📝 Test Output:")
                table.insert(content, "")
                for _, line in ipairs(result.output) do
                  table.insert(content, line)
                end
              else
                table.insert(content, "✨ No additional output captured")
              end
              
              local popup_title = string.format("🧪 %s", selection.value.name)
              create_popup(content, popup_title, 0.9, 0.85)
            end
          end)
          return true
        end,
      }):find()
    end
    
    -- Universal function to show raw test output
    function _G.show_raw_test_output()
      if not _G.test_raw_output then
        print("No raw test output available. Run tests first.")
        return
      end
      
      create_popup(_G.test_raw_output, "🔍 Raw Test Output", 0.9, 0.8)
    end
    
    -- Universal function to clear all test signs (exposed globally) 
    function _G.clear_test_signs()
      clear_test_signs()
      print("🧹 Test signs cleared")
    end
    
    -- Universal test runner functions
    function _G.run_test_file()
      local filepath = vim.fn.expand('%:p')
      local adapter = TestAdapterRegistry.get_adapter_for_file(filepath)
      
      if not adapter then
        local filetype = vim.filetype.match({ filename = filepath }) or "unknown"
        print(string.format("❌ No test adapter found for %s files", filetype))
        return
      end
      
      if not adapter.supports_file then
        print(string.format("❌ %s adapter does not support file-level tests", adapter.name))
        return
      end
      
      run_test_with_ui("file", { filepath = filepath })
    end
    
    function _G.run_test_nearest()
      local filepath = vim.fn.expand('%:p')
      local adapter = TestAdapterRegistry.get_adapter_for_file(filepath)
      
      if not adapter then
        local filetype = vim.filetype.match({ filename = filepath }) or "unknown"
        print(string.format("❌ No test adapter found for %s files", filetype))
        return
      end
      
      if not adapter.supports_nearest then
        print(string.format("❌ %s adapter does not support nearest test", adapter.name))
        return
      end
      
      local bufnr = vim.api.nvim_get_current_buf()
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
      local test_info = adapter:get_test_name_at_cursor(bufnr, cursor_line)
      
      if not test_info then
        print("❌ No test function found at cursor position")
        return
      end
      
      print(string.format("🎯 Found test: %s", test_info.name))
      run_test_with_ui("nearest", { filepath = filepath, test_info = test_info })
    end
    
    function _G.run_test_all()
      local filepath = vim.fn.expand('%:p')
      local adapter = TestAdapterRegistry.get_adapter_for_file(filepath)
      
      if not adapter then
        local filetype = vim.filetype.match({ filename = filepath }) or "unknown"
        print(string.format("❌ No test adapter found for %s files", filetype))
        return
      end
      
      if not adapter.supports_all then
        print(string.format("❌ %s adapter does not support running all tests", adapter.name))
        return
      end
      
      run_test_with_ui("all", { filepath = filepath })
    end

    -- Custom syntax highlighting for Go test output
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go-test-output",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        
        -- Define syntax highlighting
        vim.cmd([[
          syntax match GoTestPass /✅.*$/
          syntax match GoTestFail /❌.*$/
          syntax match GoTestRunning /⏳.*$/
          syntax match GoTestTitle /📊.*$/
          syntax match GoTestSummary /📈.*$/
          syntax match GoTestHint /💡.*$/
          syntax match GoTestOutput /📝.*$/
          syntax match GoTestName /🧪.*$/
          syntax match GoTestSubtests /🔍.*$/
          syntax match GoTestFailureContext /🔥.*$/
          syntax match GoTestError /❗.*$/
          syntax match GoTestWarning /⚡.*$/
          syntax match GoTestAlert /🚨.*$/
          
          highlight GoTestPass guifg=#a6e3a1 gui=bold
          highlight GoTestFail guifg=#f38ba8 gui=bold  
          highlight GoTestRunning guifg=#f9e2af gui=bold
          highlight GoTestTitle guifg=#89b4fa gui=bold
          highlight GoTestSummary guifg=#cba6f7 gui=bold
          highlight GoTestHint guifg=#94e2d5 gui=italic
          highlight GoTestOutput guifg=#fab387 gui=bold
          highlight GoTestName guifg=#f5c2e7 gui=bold
          highlight GoTestSubtests guifg=#74c7ec gui=bold
          highlight GoTestFailureContext guifg=#f38ba8 gui=bold
          highlight GoTestError guifg=#f38ba8 gui=bold
          highlight GoTestWarning guifg=#f9e2af gui=bold
          highlight GoTestAlert guifg=#ff5555 gui=bold
        ]])
      end
    })
    
    -- Enhanced Go test functions
    function _G.run_go_test_file()
      local file = vim.fn.expand('%:p')
      if not file:match('%.go$') then
        print("Not a Go file")
        return
      end
      
      local dir = vim.fn.expand('%:p:h')
      local cmd = string.format('cd %s && go test -v .', vim.fn.shellescape(dir))
      
      run_go_test_with_ui(cmd, "file tests")
    end
    
    function _G.run_go_test_nearest()
      local file = vim.fn.expand('%:p')
      if not file:match('%.go$') then
        print("Not a Go file")
        return
      end
      
      -- Enhanced test function detection for table-driven tests
      local current_line_num = vim.fn.line('.')
      local test_name = nil
      local is_table_driven = false
      
      -- First, look for the test function definition above current position
      for i = current_line_num, math.max(1, current_line_num - 200), -1 do
        local check_line = vim.fn.getline(i)
        
        -- Check if we're inside a table-driven test structure
        if check_line:match('for%s*[^{]*range%s*%[%]struct') or 
           check_line:match('tests%s*:=%s*%[%]struct') or
           check_line:match('tt%s*:=%s*range') then
          is_table_driven = true
        end
        
        -- Look for test function
        local found_test = check_line:match('func%s+%(.*%)%s+(Test%w+)') or check_line:match('func%s+(Test%w+)')
        if found_test then
          test_name = found_test
          break
        end
      end
      
      if not test_name then
        -- Fallback: check current line and immediate vicinity
        local line = vim.fn.getline('.')
        test_name = line:match('func%s+(Test%w+)')
        
        if not test_name then
          for i = math.max(1, current_line_num - 10), math.min(vim.fn.line('$'), current_line_num + 10) do
            local check_line = vim.fn.getline(i)
            test_name = check_line:match('func%s+(Test%w+)')
            if test_name then
              break
            end
          end
        end
      end
      
      if not test_name then
        print("❌ No test function found. Make sure cursor is within a test function.")
        return
      end
      
      local dir = vim.fn.expand('%:p:h')
      -- Use the parent test name for table-driven tests (this will run all subtests)
      local cmd = string.format('cd %s && go test -v -run "^%s$" .', vim.fn.shellescape(dir), test_name)
      
      local test_type_desc = is_table_driven and 
        string.format("table-driven test: %s", test_name) or 
        string.format("test: %s", test_name)
      
      print(string.format("🚀 Running %s...", test_type_desc))
      run_go_test_with_ui(cmd, test_type_desc)
    end
    
    function _G.run_go_test_all()
      local cmd = 'go test -v ./...'
      run_go_test_with_ui(cmd, "all tests")
    end

    -- Setup basic neotest without problematic Go adapter
    local ok, neotest = pcall(require, "neotest")
    if ok then
      pcall(function()
        neotest.setup({
          adapters = {
            -- Only use plenary adapter for Lua tests
            require("neotest-plenary"),
          },
          discovery = {
            enabled = false,
          },
          running = {
            concurrent = false,
          },
          output = {
            enabled = true,
            open_on_run = "short", 
          },
          quickfix = {
            enabled = false,
          },
          status = {
            enabled = true,
            signs = true,
            virtual_text = false,
          },
        })
      end)
    end
  '';
}
