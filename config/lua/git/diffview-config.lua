require("diffview").setup({
  diff_binaries = false, -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" }, -- The git executable followed by default args
  use_icons = true, -- Requires nvim-web-devicons
  icons = { -- Only applies when use_icons is true
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✅",
  },
  view = {
    default = {
      layout = "diff2_horizontal",
      winbar_info = false, -- See ':h diffview-config-view.*.winbar_info'
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers
      winbar_info = true, -- See ':h diffview-config-view.*.winbar_info'
    },
    file_history = {
      layout = "diff2_horizontal",
      winbar_info = false, -- See ':h diffview-config-view.*.winbar_info'
    },
  },
  file_panel = {
    listing_style = "tree", -- One of 'list' or 'tree'
    tree_options = { -- Only applies when listing_style is 'tree'
      flatten_dirs = true, -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'
    },
    win_config = { -- See ':h diffview-config-win_config'
      position = "left",
      width = 35,
      win_opts = {},
    },
  },
  file_history_panel = {
    log_options = { -- See ':h diffview-config-log_options'
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
    },
    win_config = { -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
      win_opts = {},
    },
  },
  commit_log_panel = {
    win_config = { -- See ':h diffview-config-win_config'
      win_opts = {},
    },
  },
  default_args = { -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {}, -- See ':h diffview-config-hooks'
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      ["<tab>"] = "select_next_entry",
      ["<s-tab>"] = "select_prev_entry",
      ["gf"] = "goto_file",
      ["<C-w><C-f>"] = "goto_file_split",
      ["<C-w>gf"] = "goto_file_tab",
      ["<leader>e"] = "focus_files",
      ["<leader>b"] = "toggle_files",
      ["g<C-x>"] = "cycle_layout",
      ["[x"] = "prev_conflict",
      ["]x"] = "next_conflict",
      ["<leader>co"] = "conflict_choose_ours",
      ["<leader>ct"] = "conflict_choose_theirs",
      ["<leader>cb"] = "conflict_choose_base",
      ["<leader>ca"] = "conflict_choose_all",
      ["dx"] = "conflict_choose_none",
    },
    diff1 = {
      -- Mappings in single window diff layouts
      ["g?"] = "help",
    },
    diff2 = {
      -- Mappings in 2-way diff layouts
      ["g?"] = "help",
    },
    diff3 = {
      -- Mappings in 3-way diff layouts
      ["g?"] = "help",
    },
    diff4 = {
      -- Mappings in 4-way diff layouts
      ["g?"] = "help",
    },
    file_panel = {
      ["j"] = "next_entry",
      ["<down>"] = "next_entry",
      ["k"] = "prev_entry",
      ["<up>"] = "prev_entry",
      ["<cr>"] = "select_entry",
      ["o"] = "select_entry",
      ["<2-LeftMouse>"] = "select_entry",
      ["-"] = "toggle_stage_entry",
      ["S"] = "stage_all",
      ["U"] = "unstage_all",
      ["X"] = "restore_entry",
      ["R"] = "refresh_files",
      ["L"] = "open_commit_log",
      ["<c-b>"] = "scroll_view(-0.25)",
      ["<c-f>"] = "scroll_view(0.25)",
      ["<tab>"] = "select_next_entry",
      ["<s-tab>"] = "select_prev_entry",
      ["gf"] = "goto_file",
      ["<C-w><C-f>"] = "goto_file_split",
      ["<C-w>gf"] = "goto_file_tab",
      ["i"] = "listing_style",
      ["f"] = "toggle_flatten_dirs",
      ["g<C-x>"] = "cycle_layout",
      ["[x"] = "prev_conflict",
      ["]x"] = "next_conflict",
    },
    file_history_panel = {
      ["g!"] = "options",
      ["<C-A-d>"] = "open_in_diffview",
      ["y"] = "copy_hash",
      ["L"] = "open_commit_log",
      ["zR"] = "open_all_folds",
      ["zM"] = "close_all_folds",
      ["j"] = "next_entry",
      ["<down>"] = "next_entry",
      ["k"] = "prev_entry",
      ["<up>"] = "prev_entry",
      ["<cr>"] = "select_entry",
      ["o"] = "select_entry",
      ["<2-LeftMouse>"] = "select_entry",
      ["<c-b>"] = "scroll_view(-0.25)",
      ["<c-f>"] = "scroll_view(0.25)",
      ["<tab>"] = "select_next_entry",
      ["<s-tab>"] = "select_prev_entry",
      ["gf"] = "goto_file",
      ["<C-w><C-f>"] = "goto_file_split",
      ["<C-w>gf"] = "goto_file_tab",
      ["<leader>e"] = "focus_files",
      ["<leader>b"] = "toggle_files",
      ["g<C-x>"] = "cycle_layout",
    },
    option_panel = {
      ["<tab>"] = "select",
      ["q"] = "close",
    },
  },
})
