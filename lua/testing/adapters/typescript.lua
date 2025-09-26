-- TypeScript/JavaScript Test Adapter
local M = {}

-- Check if this is a TypeScript/JavaScript project
function M.is_typescript_project()
  return vim.fn.filereadable("package.json") == 1 or
         vim.fn.filereadable("tsconfig.json") == 1 or
         vim.fn.filereadable("jest.config.js") == 1 or
         vim.fn.filereadable("jest.config.ts") == 1 or
         vim.fn.filereadable("vitest.config.js") == 1 or
         vim.fn.filereadable("vitest.config.ts") == 1
end

-- Get test command based on project setup
function M.get_test_command()
  if vim.fn.filereadable("package.json") == 1 then
    local package_json = vim.fn.readfile("package.json")
    local content = table.concat(package_json, "\n")
    
    -- Check for common test frameworks
    if string.find(content, '"vitest"') then
      return "npm run test"
    elseif string.find(content, '"jest"') then
      return "npm run test"
    elseif string.find(content, '"test"') then
      return "npm run test"
    else
      return "npm test"
    end
  end
  
  return "npm test"
end

-- Run all tests
function M.run_all_tests()
  if not M.is_typescript_project() then
    return false
  end
  
  local cmd = M.get_test_command()
  vim.cmd("!" .. cmd)
  return true
end

-- Run tests in current file
function M.run_file_tests()
  if not M.is_typescript_project() then
    return false
  end
  
  local current_file = vim.fn.expand("%:p")
  if not string.match(current_file, "%.test%.") and 
     not string.match(current_file, "%.spec%.") then
    print("Current file is not a test file")
    return false
  end
  
  local cmd = M.get_test_command() .. " " .. vim.fn.shellescape(current_file)
  vim.cmd("!" .. cmd)
  return true
end

-- Run nearest test (requires cursor position analysis)
function M.run_nearest_test()
  if not M.is_typescript_project() then
    return false
  end
  
  local current_file = vim.fn.expand("%:p")
  if not string.match(current_file, "%.test%.") and 
     not string.match(current_file, "%.spec%.") then
    print("Current file is not a test file")
    return false
  end
  
  -- Simple implementation - just run the file
  -- A more sophisticated implementation would parse the test structure
  return M.run_file_tests()
end

-- Get test information
function M.get_test_info()
  if not M.is_typescript_project() then
    return nil
  end
  
  return {
    name = "TypeScript/JavaScript",
    command = M.get_test_command(),
    file_patterns = {"*.test.ts", "*.test.js", "*.spec.ts", "*.spec.js"},
    supported = true
  }
end

return M