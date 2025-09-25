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
  ];

  # Configure nvim-scrollbar with theme colors
  extraConfigLua = ''
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