-- Test result browser (file name kept for compat with runner.lua;
-- the picker is now snacks.picker).

local UI = require("testing.ui")

local Telescope = {}

function Telescope.show_test_detail(test_entry)
  local result = test_entry.result
  local content = { string.format("🧪 Test: %s", test_entry.name), "" }

  if result.status then
    local status_line = string.format("📊 Status: %s", result.status:upper())
    if result.duration then
      status_line = string.format("%s (%s)", status_line, result.duration)
    end
    table.insert(content, status_line)
    table.insert(content, "")
  end

  if result.subtests and #result.subtests > 0 then
    table.insert(content, "🔍 Subtests:")
    for _, subtest in ipairs(result.subtests) do
      local icon = subtest.status == "pass" and "✅" or "❌"
      table.insert(content, string.format("  %s %s (%s)", icon, subtest.name, subtest.duration or "N/A"))
    end
    table.insert(content, "")
  end

  if result.status == "fail" and result.full_context and #result.full_context > 0 then
    table.insert(content, "🔥 Full Failure Context:")
    table.insert(content, "")
    for _, line in ipairs(result.full_context) do
      if line:match("FAIL:") or line:match("Error:") or line:match("panic:") then
        table.insert(content, "❗ " .. line)
      elseif line:match("expected") or line:match("actual") or line:match("got:") or line:match("want:") then
        table.insert(content, "⚡ " .. line)
      else
        table.insert(content, line)
      end
    end
  elseif result.output and #result.output > 0 then
    table.insert(content, "📝 Test Output:")
    table.insert(content, "")
    for _, line in ipairs(result.output) do
      table.insert(content, line)
    end
  else
    table.insert(content, "✨ No additional output captured")
  end

  UI.create_popup(content, string.format("🧪 %s", test_entry.name), 0.9, 0.85)
end

function Telescope.show_test_results()
  if not _G.test_results or vim.tbl_isempty(_G.test_results) then
    vim.notify("No test results available. Run tests first.", vim.log.levels.INFO, { title = "Tests" })
    return
  end

  local items = {}
  for test_name, result in pairs(_G.test_results) do
    local icon = result.status == "pass" and "✅" or (result.status == "fail" and "❌" or "⏳")
    local duration = result.duration and (" (" .. result.duration .. ")") or ""
    table.insert(items, {
      text = string.format("%s %s%s", icon, test_name, duration),
      name = test_name,
      result = result,
    })
  end

  Snacks.picker.pick({
    title = "Test Results",
    items = items,
    format = function(item) return { { item.text } } end,
    confirm = function(picker, item)
      picker:close()
      if item then
        Telescope.show_test_detail({ name = item.name, result = item.result })
      end
    end,
  })
end

function Telescope.show_raw_output()
  if not _G.test_raw_output then
    vim.notify("No raw test output available. Run tests first.", vim.log.levels.INFO, { title = "Tests" })
    return
  end
  UI.create_popup(vim.split(_G.test_raw_output, "\n"), "Raw Test Output", 0.9, 0.85)
end

return Telescope
