{ pkgs, ... }: let
  theme = import ./theme.nix;
in {
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
  ];

  # Basic nixvim configuration
  viAlias = true;
  vimAlias = true;
  
  # Colorscheme from theme
  colorschemes.${theme.name} = theme.colorscheme;

  # Additional packages needed by plugins
  extraPackages = with pkgs; [
    ripgrep # Required by telescope live_grep
  ];

  # Extra plugins not available in nixvim
  extraPlugins = with pkgs.vimPlugins; [
    nvim-scrollbar
    gruvbox-nvim  # Gruvbox colorscheme for dynamic switching
  ];

  # Configure nvim-scrollbar with theme colors and theme switching
  extraConfigLua = ''
    -- Theme configuration and switching
    local themes = {
      catppuccin = {
        name = "catppuccin",
        colors = {
          bg = "#1e1e2e",
          bg_alt = "#181825",
          bg_float = "#11111b",
          fg = "#cdd6f4",
          fg_alt = "#bac2de",
          blue = "#89b4fa",
          cyan = "#94e2d5",
          green = "#a6e3a1",
          yellow = "#f9e2af",
          orange = "#fab387",
          red = "#f38ba8",
          pink = "#f5c2e7",
          purple = "#cba6f7",
          border = "#585b70",
          selection = "#313244",
          search = "#f9e2af",
          git_add = "#a6e3a1",
          git_change = "#f9e2af",
          git_delete = "#f38ba8",
          error = "#f38ba8",
          warn = "#f9e2af",
          info = "#89b4fa",
          hint = "#94e2d5"
        }
      },
      gruvbox = {
        name = "gruvbox",
        colors = {
          bg = "#282828",
          bg_alt = "#1d2021",
          bg_float = "#32302f",
          fg = "#ebdbb2",
          fg_alt = "#d5c4a1",
          blue = "#83a598",
          cyan = "#8ec07c",
          green = "#b8bb26",
          yellow = "#fabd2f",
          orange = "#fe8019",
          red = "#fb4934",
          pink = "#d3869b",
          purple = "#d3869b",
          border = "#504945",
          selection = "#3c3836",
          search = "#fabd2f",
          git_add = "#b8bb26",
          git_change = "#fabd2f",
          git_delete = "#fb4934",
          error = "#fb4934",
          warn = "#fabd2f",
          info = "#83a598",
          hint = "#8ec07c"
        }
      }
    }

    -- Current theme (matches the nix config default)
    local current_theme = themes.${theme.name}

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
      local success = false
      if theme_name == "catppuccin" then
        success = pcall(vim.cmd, "colorscheme catppuccin")
      elseif theme_name == "gruvbox" then
        success = pcall(vim.cmd, "colorscheme gruvbox")
      end

      if not success then
        print("Error: Colorscheme '" .. theme_name .. "' is not available. Make sure the plugin is installed.")
        return false
      end

      -- Update current theme
      current_theme = themes[theme_name]
      
      -- Apply theme colors with error handling
      local apply_success = pcall(apply_theme_colors, current_theme)
      
      if apply_success then
        print("✓ Switched to " .. theme_name:gsub("^%l", string.upper) .. " theme")
      else
        print("✓ Switched to " .. theme_name:gsub("^%l", string.upper) .. " theme (some plugin colors may not have updated)")
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
      for name, _ in pairs(themes) do
        -- Check if colorscheme is actually available without changing the current one
        local available = false
        if name == "catppuccin" then
          available = pcall(function() 
            -- Test if the colorscheme exists without applying it
            local colorschemes = vim.fn.getcompletion("", "color")
            for _, cs in ipairs(colorschemes) do
              if cs == "catppuccin" then
                return true
              end
            end
            return false
          end)
        elseif name == "gruvbox" then
          available = pcall(function()
            -- Test if the colorscheme exists without applying it
            local colorschemes = vim.fn.getcompletion("", "color")
            for _, cs in ipairs(colorschemes) do
              if cs == "gruvbox" then
                return true
              end
            end
            return false
          end)
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

    -- Configure nvim-scrollbar with color-coded line indicators
    require('scrollbar').setup({
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,
      max_lines = false,
      hide_if_all_visible = false,
      throttle_ms = 200,
      handle = {
        text = " ",
        blend = 30,
        color = "${theme.colors.border}",
        highlight = "CursorColumn",
        hide_if_all_visible = true,
      },
      marks = {
        Cursor = {
          text = "•",
          priority = 0,
          color = "${theme.colors.fg}",
          highlight = "Normal",
        },
        Search = {
          text = { "-", "=" },
          priority = 1,
          color = "${theme.colors.search}",
          highlight = "Search",
        },
        Error = {
          text = { "─" },
          priority = 2,
          color = "${theme.colors.error}",
          highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
          text = { "─" },
          priority = 3,
          color = "${theme.colors.warn}",
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "─" },
          priority = 4,
          color = "${theme.colors.info}",
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "─" },
          priority = 5,
          color = "${theme.colors.hint}",
          highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
          text = { "-" },
          priority = 6,
          color = "${theme.colors.fg_alt}",
          highlight = "Normal",
        },
        GitAdd = {
          text = "│",
          priority = 7,
          color = "${theme.colors.git_add}",
          highlight = "GitSignsAdd",
        },
        GitChange = {
          text = "│",
          priority = 8,
          color = "${theme.colors.git_change}",
          highlight = "GitSignsChange",
        },
        GitDelete = {
          text = "│",
          priority = 9,
          color = "${theme.colors.git_delete}",
          highlight = "GitSignsDelete",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "neo-tree",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          "TextChanged",
          "VimResized",
          "WinScrolled",
        },
        clear = {
          "BufWinLeave",
          "TabLeave",
          "TermLeave",
          "WinLeave",
        },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = false,
      },
    })
    
    -- Integrate with gitsigns
    require('scrollbar.handlers.gitsigns').setup()
    
    -- Set up custom highlight groups based on theme
    vim.cmd([[
      highlight ScrollbarHandle guifg=${theme.colors.border}
      highlight ScrollbarSearchHandle guifg=${theme.colors.search}
      highlight ScrollbarErrorHandle guifg=${theme.colors.error}
      highlight ScrollbarWarnHandle guifg=${theme.colors.warn}
      highlight ScrollbarInfoHandle guifg=${theme.colors.info}
      highlight ScrollbarHintHandle guifg=${theme.colors.hint}
      highlight ScrollbarGitAddHandle guifg=${theme.colors.git_add}
      highlight ScrollbarGitChangeHandle guifg=${theme.colors.git_change}
      highlight ScrollbarGitDeleteHandle guifg=${theme.colors.git_delete}
    ]])
  '';
}