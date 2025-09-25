{ theme }: {
  # Theme switching and configuration
  extraConfigLua = ''
    -- Theme configuration and switching
    local themes = {
      catppuccin = {
        name = "catppuccin",
        colors = {
          bg = "#1e1e2e", bg_alt = "#181825", bg_float = "#11111b",
          fg = "#cdd6f4", fg_alt = "#bac2de",
          blue = "#89b4fa", cyan = "#94e2d5", green = "#a6e3a1", yellow = "#f9e2af",
          orange = "#fab387", red = "#f38ba8", pink = "#f5c2e7", purple = "#cba6f7",
          border = "#585b70", selection = "#313244", search = "#f9e2af",
          git_add = "#a6e3a1", git_change = "#f9e2af", git_delete = "#f38ba8",
          error = "#f38ba8", warn = "#f9e2af", info = "#89b4fa", hint = "#94e2d5"
        }
      },
      gruvbox = {
        name = "gruvbox",
        colors = {
          bg = "#282828", bg_alt = "#1d2021", bg_float = "#32302f",
          fg = "#ebdbb2", fg_alt = "#d5c4a1",
          blue = "#83a598", cyan = "#8ec07c", green = "#b8bb26", yellow = "#fabd2f",
          orange = "#fe8019", red = "#fb4934", pink = "#d3869b", purple = "#d3869b",
          border = "#504945", selection = "#3c3836", search = "#fabd2f",
          git_add = "#b8bb26", git_change = "#fabd2f", git_delete = "#fb4934",
          error = "#fb4934", warn = "#fabd2f", info = "#83a598", hint = "#8ec07c"
        }
      },
      tokyonight = {
        name = "tokyonight",
        colors = {
          bg = "#1a1b26", bg_alt = "#16161e", bg_float = "#16161e",
          fg = "#c0caf5", fg_alt = "#9aa5ce",
          blue = "#7aa2f7", cyan = "#7dcfff", green = "#9ece6a", yellow = "#e0af68",
          orange = "#ff9e64", red = "#f7768e", pink = "#bb9af7", purple = "#9d7cd8",
          border = "#27283d", selection = "#283457", search = "#e0af68",
          git_add = "#9ece6a", git_change = "#e0af68", git_delete = "#f7768e",
          error = "#f7768e", warn = "#e0af68", info = "#7aa2f7", hint = "#7dcfff"
        }
      },
      nord = {
        name = "nord",
        colors = {
          bg = "#2e3440", bg_alt = "#3b4252", bg_float = "#3b4252",
          fg = "#eceff4", fg_alt = "#d8dee9",
          blue = "#5e81ac", cyan = "#88c0d0", green = "#a3be8c", yellow = "#ebcb8b",
          orange = "#d08770", red = "#bf616a", pink = "#b48ead", purple = "#b48ead",
          border = "#4c566a", selection = "#434c5e", search = "#ebcb8b",
          git_add = "#a3be8c", git_change = "#ebcb8b", git_delete = "#bf616a",
          error = "#bf616a", warn = "#ebcb8b", info = "#5e81ac", hint = "#88c0d0"
        }
      },
      onedark = {
        name = "onedark",
        colors = {
          bg = "#282c34", bg_alt = "#21252b", bg_float = "#21252b",
          fg = "#abb2bf", fg_alt = "#828997",
          blue = "#61afef", cyan = "#56b6c2", green = "#98c379", yellow = "#e5c07b",
          orange = "#d19a66", red = "#e06c75", pink = "#c678dd", purple = "#c678dd",
          border = "#3e4451", selection = "#3e4451", search = "#e5c07b",
          git_add = "#98c379", git_change = "#e5c07b", git_delete = "#e06c75",
          error = "#e06c75", warn = "#e5c07b", info = "#61afef", hint = "#56b6c2"
        }
      },
      nightfox = {
        name = "nightfox",
        colors = {
          bg = "#192330", bg_alt = "#131a24", bg_float = "#131a24",
          fg = "#cdcecf", fg_alt = "#aeafb0",
          blue = "#719cd6", cyan = "#63cdcf", green = "#81b29a", yellow = "#dbc074",
          orange = "#f4a261", red = "#c94f6d", pink = "#d67ad2", purple = "#9d79d6",
          border = "#2b3b51", selection = "#2b3b51", search = "#dbc074",
          git_add = "#81b29a", git_change = "#dbc074", git_delete = "#c94f6d",
          error = "#c94f6d", warn = "#dbc074", info = "#719cd6", hint = "#63cdcf"
        }
      },
      dracula = {
        name = "dracula",
        colors = {
          bg = "#282a36", bg_alt = "#21222c", bg_float = "#21222c",
          fg = "#f8f8f2", fg_alt = "#6272a4",
          blue = "#8be9fd", cyan = "#8be9fd", green = "#50fa7b", yellow = "#f1fa8c",
          orange = "#ffb86c", red = "#ff5555", pink = "#ff79c6", purple = "#bd93f9",
          border = "#44475a", selection = "#44475a", search = "#f1fa8c",
          git_add = "#50fa7b", git_change = "#f1fa8c", git_delete = "#ff5555",
          error = "#ff5555", warn = "#f1fa8c", info = "#8be9fd", hint = "#8be9fd"
        }
      },
      kanagawa = {
        name = "kanagawa",
        colors = {
          bg = "#1f1f28", bg_alt = "#16161d", bg_float = "#16161d",
          fg = "#dcd7ba", fg_alt = "#c8c093",
          blue = "#7e9cd8", cyan = "#7fb4ca", green = "#98bb6c", yellow = "#e6c384",
          orange = "#ffa066", red = "#c34043", pink = "#d27e99", purple = "#957fb8",
          border = "#54546d", selection = "#2d4f67", search = "#e6c384",
          git_add = "#98bb6c", git_change = "#e6c384", git_delete = "#c34043",
          error = "#c34043", warn = "#e6c384", info = "#7e9cd8", hint = "#7fb4ca"
        }
      },
      ["rose-pine"] = {
        name = "rose-pine",
        colors = {
          bg = "#191724", bg_alt = "#1f1d2e", bg_float = "#1f1d2e",
          fg = "#e0def4", fg_alt = "#908caa",
          blue = "#9ccfd8", cyan = "#9ccfd8", green = "#31748f", yellow = "#f6c177",
          orange = "#f6c177", red = "#eb6f92", pink = "#eb6f92", purple = "#c4a7e7",
          border = "#403d52", selection = "#403d52", search = "#f6c177",
          git_add = "#31748f", git_change = "#f6c177", git_delete = "#eb6f92",
          error = "#eb6f92", warn = "#f6c177", info = "#9ccfd8", hint = "#9ccfd8"
        }
      }
    }

    -- Theme persistence
    local data_dir = vim.fn.stdpath("data")
    local theme_file = data_dir .. "/theme.txt"

    -- Function to save current theme
    local function save_theme(theme_name)
      local file = io.open(theme_file, "w")
      if file then
        file:write(theme_name)
        file:close()
      end
    end

    -- Function to load saved theme
    local function load_saved_theme()
      local file = io.open(theme_file, "r")
      if file then
        local saved_theme = file:read("*all"):gsub("%s+", "") -- trim whitespace
        file:close()
        if saved_theme and saved_theme ~= "" and themes[saved_theme] then
          return saved_theme
        end
      end
      return "${theme.name}" -- fallback to nix config default
    end

    -- Load saved theme or use default
    local saved_theme_name = load_saved_theme()
    local current_theme = themes[saved_theme_name]

    -- Apply saved theme on startup if different from nix default
    if saved_theme_name ~= "${theme.name}" then
      -- Use autocmd to ensure plugins are loaded before applying theme
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        once = true,
        callback = function()
          vim.defer_fn(function()
            local success = pcall(vim.cmd, "colorscheme " .. saved_theme_name)
            if success then
              pcall(apply_theme_colors, current_theme)
            end
          end, 50)
        end
      })
    end

    -- Function to apply theme colors to various plugins
    local function apply_theme_colors(theme_data)
      local colors = theme_data.colors
      
      -- Update scrollbar colors
      if package.loaded['scrollbar'] then
        pcall(function()
          require('scrollbar').setup({
            handle = { color = colors.border },
            marks = {
              Cursor = { color = colors.fg },
              Search = { color = colors.search },
              Error = { color = colors.error },
              Warn = { color = colors.warn },
              Info = { color = colors.info },
              Hint = { color = colors.hint },
              GitAdd = { color = colors.git_add },
              GitChange = { color = colors.git_change },
              GitDelete = { color = colors.git_delete }
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
        colors.border, colors.search, colors.error, colors.warn, 
        colors.info, colors.hint, colors.git_add, colors.git_change, 
        colors.git_delete, colors.border, colors.border, colors.border,
        colors.border, colors.border
      ))

      -- Update bufferline colors if available
      if package.loaded['bufferline'] then
        local ok, bufferline = pcall(require, 'bufferline')
        if ok then
          -- Try to refresh bufferline safely
          pcall(function()
            if vim.fn.exists(':BufferLineRefresh') > 0 then
              vim.cmd('BufferLineRefresh')
            end
          end)
        end
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
          ]], colors.git_add, colors.git_change, colors.git_delete))
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
          ]], colors.error, colors.warn, colors.info, colors.hint))
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

    -- Function to switch theme dynamically
    function _G.switch_theme(theme_name)
      if not themes[theme_name] then
        print("Theme '" .. theme_name .. "' not found. Available: catppuccin, gruvbox")
        return false
      end

      -- Switch colorscheme with error handling
      local success = pcall(vim.cmd, "colorscheme " .. theme_name)

      if not success then
        print("Error: Colorscheme '" .. theme_name .. "' is not available. Make sure the plugin is installed.")
        return false
      end

      -- Update current theme
      current_theme = themes[theme_name]
      
      -- Save theme for persistence
      save_theme(theme_name)
      
      -- Apply theme colors with error handling
      local apply_success = pcall(apply_theme_colors, current_theme)
      
      if apply_success then
        print("✓ Switched to " .. theme_name:gsub("^%l", string.upper) .. " theme (saved)")
      else
        print("✓ Switched to " .. theme_name:gsub("^%l", string.upper) .. " theme (saved, some plugin colors may not have updated)")
      end
      
      return true
    end

    -- Function to check if a colorscheme is available
    local function is_colorscheme_available(name)
      return pcall(vim.cmd, "colorscheme " .. name)
    end

    -- Theme picker function
    function _G.theme_picker()
      -- Save current colorscheme before checking availability
      local current_colorscheme = vim.g.colors_name or "default"
      
      local theme_names = {}
      local colorschemes = vim.fn.getcompletion("", "color")
      
      for name, _ in pairs(themes) do
        -- Check if colorscheme is actually available without changing the current one
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

      vim.ui.select(theme_names, {
        prompt = "Select theme (Current: " .. (current_theme.name:gsub("^%l", string.upper)) .. "):",
        format_item = function(item)
          local display = item:gsub("^%l", string.upper)
          if item == current_theme.name then
            display = display .. " ✓"
          end
          return display
        end
      }, function(choice)
        if choice then
          _G.switch_theme(choice)
        end
      end)
    end

    -- Function to get current saved theme
    function _G.get_saved_theme()
      local saved = load_saved_theme()
      print("Current saved theme: " .. saved:gsub("^%l", string.upper))
      print("Theme file location: " .. theme_file)
      return saved
    end

    -- Function to reset to default theme
    function _G.reset_theme_to_default()
      local default_theme = "${theme.name}"
      _G.switch_theme(default_theme)
      print("Reset to default theme: " .. default_theme:gsub("^%l", string.upper))
    end
  '';
}

