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
    # Nerd Fonts for proper icon display
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    # Debugging tools
    delve # Go debugger
  ];

  # Extra plugins not available in nixvim
  extraPlugins = with pkgs.vimPlugins; [
    nvim-scrollbar

    # Popular colorschemes
    gruvbox-nvim          # Gruvbox - retro groove colors
    tokyonight-nvim       # Tokyo Night - modern dark theme
    nord-nvim             # Nord - arctic, north-bluish theme
    onedark-nvim          # OneDark - Atom's iconic One Dark theme
    nightfox-nvim         # Nightfox - highly customizable theme
    dracula-nvim          # Dracula - dark theme inspired by the famous color palette
    kanagawa-nvim         # Kanagawa - inspired by the famous painting
    rose-pine             # Rosé Pine - soho vibes theme

    # Testing and debugging plugins  
    neotest-go            # Go test adapter for neotest
    neotest-plenary       # Plenary test adapter
  ];

  # Configure nvim-scrollbar with theme colors and theme switching
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
    
    -- Configure web-devicons with fallback icons for better compatibility
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if ok then
      devicons.setup({
        override = {
          default_icon = { icon = "📄", name = "Default" },
        },
        default = true,
        strict = true,
        override_by_filename = {
          [".gitignore"] = { icon = "🚫", name = "Gitignore" },
          ["README.md"] = { icon = "📖", name = "Readme" },
          ["Makefile"] = { icon = "🔨", name = "Makefile" },
          ["Dockerfile"] = { icon = "🐳", name = "Docker" },
        },
        override_by_extension = {
          ["nix"] = { icon = "❄️", name = "Nix" },
          ["go"] = { icon = "🐹", name = "Go" },
          ["js"] = { icon = "📜", name = "JavaScript" },
          ["ts"] = { icon = "📘", name = "TypeScript" },
          ["lua"] = { icon = "🌙", name = "Lua" },
          ["py"] = { icon = "🐍", name = "Python" },
          ["rs"] = { icon = "🦀", name = "Rust" },
          ["md"] = { icon = "📝", name = "Markdown" },
          ["json"] = { icon = "📋", name = "JSON" },
          ["yaml"] = { icon = "📋", name = "YAML" },
          ["yml"] = { icon = "📋", name = "YAML" },
          ["toml"] = { icon = "📋", name = "TOML" },
        },
      })
    end
    
    -- Enhanced Go testing with beautiful UI and telescope integration
    -- Test results storage
    _G.go_test_results = {}
    
    -- Define custom signs for test status
    vim.fn.sign_define("test_pass", {
      text = "│",
      texthl = "TestPassSign",
      linehl = "",
      numhl = ""
    })
    
    vim.fn.sign_define("test_fail", {
      text = "│",
      texthl = "TestFailSign", 
      linehl = "",
      numhl = ""
    })
    
    vim.fn.sign_define("test_running", {
      text = "│",
      texthl = "TestRunningSign",
      linehl = "",
      numhl = ""
    })
    
    -- Define highlight groups for test signs
    vim.cmd([[
      highlight TestPassSign guifg=#a6e3a1 gui=bold
      highlight TestFailSign guifg=#f38ba8 gui=bold  
      highlight TestRunningSign guifg=#f9e2af gui=bold
    ]])
    
    -- Function to clear all test signs in current buffer
    local function clear_test_signs()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.fn.sign_unplace("test_signs", { buffer = bufnr })
    end
    
    -- Function to find test function line numbers in current buffer  
    local function find_test_functions()
      local test_functions = {}
      local bufnr = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      
      for line_num, line in ipairs(lines) do
        local test_name = line:match('func%s+%(.*%)%s+(Test%w+)') or line:match('func%s+(Test%w+)')
        if test_name then
          test_functions[test_name] = line_num
        end
      end
      
      return test_functions
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
    
    -- Function to parse Go test output
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
    
    -- Function to show test results in telescope
    function _G.show_test_results_telescope()
      if not _G.go_test_results or vim.tbl_isempty(_G.go_test_results) then
        print("No test results available. Run tests first.")
        return
      end
      
      local pickers = require "telescope.pickers"
      local finders = require "telescope.finders"
      local conf = require("telescope.config").values
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"
      
      local results = {}
      for test_name, result in pairs(_G.go_test_results) do
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
    
    -- Function to show raw test output
    function _G.show_raw_test_output()
      if not _G.go_test_raw_output then
        print("No raw test output available. Run tests first.")
        return
      end
      
      create_popup(_G.go_test_raw_output, "🔍 Raw Test Output", 0.9, 0.8)
    end
    
    -- Function to clear all test signs (exposed globally)
    function _G.clear_go_test_signs()
      clear_test_signs()
      print("🧹 Test signs cleared")
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
