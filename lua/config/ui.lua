-- UI configuration module
-- Scrollbar and other visual components
-- Note: Icons are handled by mini.icons (see config/plugins/ui/icons.nix)

local M = {}

-- Setup scrollbar with theme colors
function M.setup_scrollbar(colors)
  local ok, scrollbar = pcall(require, 'scrollbar')
  if not ok then
    return
  end

  scrollbar.setup({
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
      color = colors.border,
      highlight = "CursorColumn",
      hide_if_all_visible = true,
    },
    marks = {
      Cursor = {
        text = ".",
        priority = 0,
        color = colors.fg,
        highlight = "Normal",
      },
      Error = {
        text = { "-" },
        priority = 2,
        color = colors.error,
        highlight = "DiagnosticVirtualTextError",
      },
      Warn = {
        text = { "-" },
        priority = 3,
        color = colors.warn,
        highlight = "DiagnosticVirtualTextWarn",
      },
      Info = {
        text = { "-" },
        priority = 4,
        color = colors.info,
        highlight = "DiagnosticVirtualTextInfo",
      },
      Hint = {
        text = { "-" },
        priority = 5,
        color = colors.hint,
        highlight = "DiagnosticVirtualTextHint",
      },
      GitAdd = {
        text = "|",
        priority = 6,
        color = colors.git_add,
        highlight = "GitSignsAdd",
      },
      GitChange = {
        text = "|",
        priority = 7,
        color = colors.git_change,
        highlight = "GitSignsChange",
      },
      GitDelete = {
        text = "_",
        priority = 8,
        color = colors.git_delete,
        highlight = "GitSignsDelete",
      },
    },
    excluded_buftypes = {
      "terminal",
    },
    excluded_filetypes = {
      "cmp_docs",
      "cmp_menu",
      "noice",
      "prompt",
      "TelescopePrompt",
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
      search = false,  -- Disable search handler to avoid hlslens dependency
    },
  })

  -- Integrate with gitsigns
  local gitsigns_ok = pcall(require, 'scrollbar.handlers.gitsigns')
  if gitsigns_ok then
    require('scrollbar.handlers.gitsigns').setup()
  end

  -- Set up custom highlight groups
  vim.cmd(string.format([[
    highlight ScrollbarHandle guifg=%s
    highlight ScrollbarErrorHandle guifg=%s
    highlight ScrollbarWarnHandle guifg=%s
    highlight ScrollbarInfoHandle guifg=%s
    highlight ScrollbarHintHandle guifg=%s
    highlight ScrollbarGitAddHandle guifg=%s
    highlight ScrollbarGitChangeHandle guifg=%s
    highlight ScrollbarGitDeleteHandle guifg=%s
  ]], colors.border, colors.error, colors.warn, colors.info,
      colors.hint, colors.git_add, colors.git_change, colors.git_delete))
end

-- Main setup function
function M.setup(colors)
  M.setup_scrollbar(colors)
  -- Icons are now handled by mini.icons with nvim-web-devicons compatibility shim
end

return M
