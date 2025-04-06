local keymaps = require("editor/keymappings")

require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = "minimal",
    border = "rounded",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  --yadm = {
  --  enable = false
  --},
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    map("n", "<leader>ts", gs.stage_hunk)
    map("n", "<leader>tr", gs.reset_hunk)
    map("v", "<leader>ts", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("v", "<leader>tr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("n", "<leader>tS", gs.stage_buffer)
    map("n", "<leader>tu", gs.undo_stage_hunk)
    map("n", "<leader>tR", gs.reset_buffer)
    map("n", "<leader>tp", gs.preview_hunk)
    map("n", "<leader>tb", function()
      gs.blame()
    end)
    map("n", "<leader>tB", gs.toggle_current_line_blame)
    map("n", "<leader>td", gs.diffthis)
    map("n", "<leader>tD", function()
      gs.diffthis("~")
    end)
    map("n", "<leader>td", gs.toggle_deleted)

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})
