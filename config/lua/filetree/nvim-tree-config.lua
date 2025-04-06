-- File tree visualiser

local keymaps = require("editor/keymappings")

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,

  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,

  diagnostics = {
    enable = true,
    icons = {
      hint = "💡",
      info = "💬",
      warning = "⚠️",
      error = "🚨",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  view = {
    adaptive_size = true,
    centralize_selection = true,
    side = "left",
    float = {
      enable = true,
      open_win_config = {
        border = "rounded",
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = true,
    },
  },
})

keymaps.open_file_tree(":NvimTreeToggle<cr>")
keymaps.refresh_file_in_tree(":NvimTreeRefresh<cr>")
keymaps.find_file_in_tree(":NvimTreeFindFile<cr>")
