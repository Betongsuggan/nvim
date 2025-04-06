-- Configuration for searching for files and content
local keymaps = require("editor/keymappings")
local telescope = require("telescope")
local builtins = require("telescope.builtin")

telescope.setup()

-- Load telescope extensions
telescope.load_extension("gh")

keymaps.search_file_name(builtins.find_files)
keymaps.search_directory_contents(builtins.live_grep)
keymaps.search_symbols(builtins.lsp_dynamic_workspace_symbols)
keymaps.search_buffer_names(builtins.buffers)
keymaps.search_help_tags(builtins.help_tags)

-- Git specific keymaps
vim.keymap.set("n", "<leader>gc", builtins.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>gb", builtins.git_branches, { desc = "Git branches" })
vim.keymap.set("n", "<leader>gs", builtins.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gf", builtins.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>gh", builtins.git_stash, { desc = "Git stash" })
vim.keymap.set("n", "<leader>gB", builtins.git_bcommits, { desc = "Git buffer commits" })
