-- Telescope Integration for Test Results
-- Provides interactive test result viewer and navigation

local UI = require('testing.ui')

local Telescope = {}

-- Show test results in telescope with interactive selection
function Telescope.show_test_results()
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
    prompt_title = "🧪 Test Results",
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
          Telescope.show_test_detail(selection.value)
        end
      end)
      return true
    end,
  }):find()
end

-- Show detailed test result in popup
function Telescope.show_test_detail(test_entry)
  local result = test_entry.result
  local test_title = string.format("🧪 Test: %s", test_entry.name)
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
  
  local popup_title = string.format("🧪 %s", test_entry.name)
  UI.create_popup(content, popup_title, 0.9, 0.85)
end

-- Show raw test output in popup
function Telescope.show_raw_output()
  if not _G.test_raw_output then
    print("No raw test output available. Run tests first.")
    return
  end
  
  local lines = vim.split(_G.test_raw_output, '\n')
  UI.create_popup(lines, "🔍 Raw Test Output", 0.9, 0.85)
end

return Telescope