-- Base Test Adapter Interface
-- Each language adapter should implement these methods

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

return TestAdapter

