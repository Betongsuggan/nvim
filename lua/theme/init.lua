-- Theme switching and persistence module
-- Single source of truth for theme management

local colors = require('theme.colors')

local M = {}

-- Theme persistence file location
local data_dir = vim.fn.stdpath("data")
local theme_file = data_dir .. "/theme.txt"

-- Current theme state (will be set on load)
M.current = nil

-- Save theme to persistence file
local function save_theme(theme_name)
  local file = io.open(theme_file, "w")
  if file then
    file:write(theme_name)
    file:close()
  end
end

-- Load saved theme from persistence file
local function load_saved_theme()
  local file = io.open(theme_file, "r")
  if file then
    local saved_theme = file:read("*all"):gsub("%s+", "") -- trim whitespace
    file:close()
    if saved_theme and saved_theme ~= "" and colors.get(saved_theme) then
      return saved_theme
    end
  end
  return nil
end

-- Apply theme colors to various plugins
local function apply_theme_colors(theme_data)
  local c = theme_data.colors

  -- Update scrollbar colors
  if package.loaded['scrollbar'] then
    pcall(function()
      require('scrollbar').setup({
        handle = { color = c.border },
        marks = {
          Cursor = { color = c.fg },
          Search = { color = c.search },
          Error = { color = c.error },
          Warn = { color = c.warn },
          Info = { color = c.info },
          Hint = { color = c.hint },
          GitAdd = { color = c.git_add },
          GitChange = { color = c.git_change },
          GitDelete = { color = c.git_delete }
        }
      })
    end)
  end

  -- Update highlight groups
  vim.cmd(string.format([[
    highlight ScrollbarHandle guifg=%s
    highlight ScrollbarSearchHandle guifg=%s
    highlight ScrollbarErrorHandle guifg=%s
    highlight ScrollbarWarnHandle guifg=%s
    highlight ScrollbarInfoHandle guifg=%s
    highlight ScrollbarHintHandle guifg=%s
    highlight ScrollbarGitAddHandle guifg=%s
    highlight ScrollbarGitChangeHandle guifg=%s
    highlight ScrollbarGitDeleteHandle guifg=%s
    highlight TelescopeBorder guifg=%s
    highlight TelescopePromptBorder guifg=%s
    highlight TelescopeResultsBorder guifg=%s
    highlight TelescopePreviewBorder guifg=%s
    highlight FloatBorder guifg=%s
  ]],
    c.border, c.search, c.error, c.warn,
    c.info, c.hint, c.git_add, c.git_change,
    c.git_delete, c.border, c.border, c.border,
    c.border, c.border
  ))

  -- Update completion menu styling
  vim.api.nvim_set_hl(0, 'CmpPmenu', { bg = c.bg, fg = c.fg })
  vim.api.nvim_set_hl(0, 'CmpSel', { bg = c.selection, fg = c.fg, bold = true })
  vim.api.nvim_set_hl(0, 'CmpBorder', { fg = c.border })
  vim.api.nvim_set_hl(0, 'CmpDoc', { bg = c.bg_alt, fg = c.fg })
  vim.api.nvim_set_hl(0, 'CmpDocBorder', { fg = c.border })
  vim.api.nvim_set_hl(0, 'CmpGhostText', { fg = c.border, italic = true })

  -- Completion kind highlights
  vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = c.blue })
  vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = c.blue })
  vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = c.red })
  vim.api.nvim_set_hl(0, 'CmpItemKindField', { fg = c.red })
  vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { fg = c.purple })
  vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = c.green })
  vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = c.fg })

  -- Custom cursorline highlighting
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = c.selection, underline = false })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = c.orange, bold = true })

  -- Update bufferline colors if available
  if package.loaded['bufferline'] then
    pcall(function()
      if vim.fn.exists(':BufferLineRefresh') > 0 then
        vim.cmd('BufferLineRefresh')
      end
    end)
  end

  -- Refresh lualine if available
  if package.loaded['lualine'] then
    pcall(function()
      require('lualine').setup({
        options = { theme = theme_data.name }
      })
    end)
  end

  -- Update gitsigns colors if available
  if package.loaded['gitsigns'] then
    pcall(function()
      vim.cmd(string.format([[
        highlight GitSignsAdd guifg=%s
        highlight GitSignsChange guifg=%s
        highlight GitSignsDelete guifg=%s
      ]], c.git_add, c.git_change, c.git_delete))
    end)
  end

  -- Update trouble diagnostic colors if available
  if package.loaded['trouble'] then
    pcall(function()
      vim.cmd(string.format([[
        highlight TroubleError guifg=%s
        highlight TroubleWarning guifg=%s
        highlight TroubleInformation guifg=%s
        highlight TroubleHint guifg=%s
      ]], c.error, c.warn, c.info, c.hint))
    end)
  end

  -- Refresh plugins that need it
  vim.cmd('redraw!')

  -- Refresh neo-tree if open
  pcall(function()
    if vim.fn.exists(':Neotree') > 0 then
      vim.cmd('Neotree refresh')
    end
  end)
end

-- Switch to a different theme
function M.switch(theme_name)
  local theme_data = colors.get(theme_name)
  if not theme_data then
    local available = table.concat(colors.available(), ", ")
    print("Theme '" .. theme_name .. "' not found. Available: " .. available)
    return false
  end

  -- Switch colorscheme with error handling
  local success = pcall(vim.cmd, "colorscheme " .. theme_name)

  if not success then
    print("Error: Colorscheme '" .. theme_name .. "' is not available. Make sure the plugin is installed.")
    return false
  end

  -- Update current theme
  M.current = theme_data

  -- Save theme for persistence
  save_theme(theme_name)

  -- Apply theme colors with error handling
  local apply_success = pcall(apply_theme_colors, theme_data)

  if apply_success then
    print("Switched to " .. theme_name:gsub("^%l", string.upper) .. " theme (saved)")
  else
    print("Switched to " .. theme_name:gsub("^%l", string.upper) .. " theme (saved, some plugin colors may not have updated)")
  end

  return true
end

-- Theme picker using vim.ui.select
function M.picker()
  -- Save current colorscheme before checking availability
  local current_colorscheme = vim.g.colors_name or "default"

  local theme_names = {}
  local colorschemes = vim.fn.getcompletion("", "color")

  for _, name in ipairs(colors.available()) do
    -- Check if colorscheme is actually available
    local available = false
    for _, cs in ipairs(colorschemes) do
      if cs == name then
        available = true
        break
      end
    end

    if available then
      table.insert(theme_names, name)
    end
  end

  -- Restore the original colorscheme
  pcall(vim.cmd, "colorscheme " .. current_colorscheme)

  if #theme_names == 0 then
    print("No themes available. Make sure colorscheme plugins are installed.")
    return
  end

  local current_name = M.current and M.current.name or "unknown"

  vim.ui.select(theme_names, {
    prompt = "Select theme (Current: " .. current_name:gsub("^%l", string.upper) .. "):",
    format_item = function(item)
      local display = item:gsub("^%l", string.upper)
      if M.current and item == M.current.name then
        display = display .. " [current]"
      end
      return display
    end
  }, function(choice)
    if choice then
      M.switch(choice)
    end
  end)
end

-- Get current saved theme info
function M.get_saved()
  local saved = load_saved_theme()
  if saved then
    print("Current saved theme: " .. saved:gsub("^%l", string.upper))
    print("Theme file location: " .. theme_file)
  else
    print("No saved theme found")
  end
  return saved
end

-- Get current theme colors
function M.get_colors()
  if M.current then
    return M.current.colors
  end
  return nil
end

-- Setup function - initializes theme system
-- default_theme: the theme name set in Nix config (fallback)
function M.setup(default_theme)
  default_theme = default_theme or "catppuccin"

  -- Try to load saved theme, fall back to default
  local saved_theme_name = load_saved_theme() or default_theme
  local theme_data = colors.get(saved_theme_name)

  if not theme_data then
    theme_data = colors.get(default_theme)
    saved_theme_name = default_theme
  end

  M.current = theme_data

  -- Apply saved theme on startup if different from Nix default
  if saved_theme_name ~= default_theme then
    -- Use autocmd to ensure plugins are loaded before applying theme
    vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      once = true,
      callback = function()
        vim.defer_fn(function()
          local success = pcall(vim.cmd, "colorscheme " .. saved_theme_name)
          if success then
            pcall(apply_theme_colors, M.current)
          end
        end, 50)
      end
    })
  else
    -- Apply colors immediately for the default theme
    vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      once = true,
      callback = function()
        vim.defer_fn(function()
          pcall(apply_theme_colors, M.current)
        end, 50)
      end
    })
  end

  -- Export global functions for keymaps
  _G.theme_picker = function() M.picker() end
  _G.switch_theme = function(name) M.switch(name) end
  _G.get_saved_theme = function() M.get_saved() end
  _G.reset_theme_to_default = function()
    M.switch(default_theme)
    print("Reset to default theme: " .. default_theme:gsub("^%l", string.upper))
  end
end

return M
