-- Test Adapter Registry
-- Manages registration and selection of language adapters

local Registry = {}

-- Initialize global storage
if not _G.test_adapters then
  _G.test_adapters = {}
end

function Registry.register(adapter)
  if not adapter.name then
    error("Adapter must have a name")
  end
  _G.test_adapters[adapter.name] = adapter
  print("✓ Registered test adapter: " .. adapter.name)
end

function Registry.get_adapter_for_file(filepath)
  local filetype = vim.filetype.match({ filename = filepath }) or ""
  local extension = filepath:match("%.([^%.]+)$") or ""

  -- First, try exact test file matching
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

function Registry.list_adapters()
  local adapters = {}
  for name, adapter in pairs(_G.test_adapters) do
    table.insert(adapters, {
      name = name,
      file_patterns = adapter.file_patterns,
      supports_nearest = adapter.supports_nearest,
      supports_file = adapter.supports_file,
      supports_all = adapter.supports_all,
    })
  end
  return adapters
end

return Registry

