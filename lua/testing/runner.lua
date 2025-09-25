-- Main Test Runner
-- Coordinates test execution, result handling, and UI updates

local Registry = require('testing.registry')
local UI = require('testing.ui')
local Telescope = require('testing.telescope')

local Runner = {}

-- Initialize the test runner system
function Runner.setup()
  -- Setup UI components
  UI.setup_test_signs()
  UI.setup_test_syntax()
  
  -- Initialize global storage
  if not _G.test_results then
    _G.test_results = {}
  end
  
  -- Register available adapters
  local GoAdapter = require('testing.adapters.go')
  Registry.register(GoAdapter)
end

-- Run test with UI feedback
function Runner.run_test_with_ui(cmd, test_type, adapter)
  -- Show running status in gutter first
  local bufnr = vim.api.nvim_get_current_buf()
  local test_functions = adapter:find_test_functions(bufnr)
  
  -- Mark all found tests as running
  UI.clear_test_signs()
  for test_name, line_num in pairs(test_functions) do
    UI.mark_test_function(test_name, "running", line_num)
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
  
  -- Parse results using adapter
  local parsed_results = adapter:parse_test_output(output)
  _G.test_results = parsed_results
  
  -- Update gutter signs based on results
  UI.update_test_signs(parsed_results, test_functions)
  
  -- Show brief status message
  local status_msg = UI.format_test_status(parsed_results)
  print(string.format("%s - Press <leader>to for details", status_msg))
  
  -- Store raw output for viewing
  _G.test_raw_output = output
end

-- Run nearest test function
function Runner.run_nearest_test()
  local filepath = vim.fn.expand('%:p')
  local adapter = Registry.get_adapter_for_file(filepath)
  
  if not adapter then
    print("❌ No test adapter found for this file type")
    return
  end
  
  if not adapter.supports_nearest then
    print("❌ This adapter doesn't support running nearest test")
    return
  end
  
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local test_info = adapter:get_test_name_at_cursor(bufnr, cursor_line)
  
  if not test_info then
    print("❌ No test function found at cursor")
    return
  end
  
  local cmd = adapter:build_test_command("nearest", { test_info = test_info })
  if not cmd then
    print("❌ Failed to build test command")
    return
  end
  
  Runner.run_test_with_ui(cmd, "nearest test", adapter)
end

-- Run all tests in current file
function Runner.run_file_tests()
  local filepath = vim.fn.expand('%:p')
  local adapter = Registry.get_adapter_for_file(filepath)
  
  if not adapter then
    print("❌ No test adapter found for this file type")
    return
  end
  
  if not adapter.supports_file then
    print("❌ This adapter doesn't support running file tests")
    return
  end
  
  local cmd = adapter:build_test_command("file", {})
  if not cmd then
    print("❌ Failed to build test command")
    return
  end
  
  Runner.run_test_with_ui(cmd, "file tests", adapter)
end

-- Run all tests in project
function Runner.run_all_tests()
  local filepath = vim.fn.expand('%:p')
  local adapter = Registry.get_adapter_for_file(filepath)
  
  if not adapter then
    print("❌ No test adapter found for this file type")
    return
  end
  
  if not adapter.supports_all then
    print("❌ This adapter doesn't support running all tests")
    return
  end
  
  local cmd = adapter:build_test_command("all", {})
  if not cmd then
    print("❌ Failed to build test command")
    return
  end
  
  Runner.run_test_with_ui(cmd, "all tests", adapter)
end

-- Show test results in telescope
function Runner.show_test_results()
  Telescope.show_test_results()
end

-- Show raw test output
function Runner.show_raw_output()
  Telescope.show_raw_output()
end

-- Clear test signs from current buffer
function Runner.clear_test_signs()
  UI.clear_test_signs()
end

-- Get test info at cursor (for debugging)
function Runner.debug_test_info()
  local filepath = vim.fn.expand('%:p')
  local adapter = Registry.get_adapter_for_file(filepath)
  
  if not adapter then
    print("❌ No test adapter found for this file type")
    return
  end
  
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local test_info = adapter:get_test_name_at_cursor(bufnr, cursor_line)
  
  if test_info then
    print(string.format("🧪 Test: %s (line %d) - Table driven: %s", 
      test_info.name, test_info.line, tostring(test_info.is_table_driven)))
  else
    print("❌ No test function found at cursor")
  end
end

return Runner