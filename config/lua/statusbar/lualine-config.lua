-- Status bar on be bottom

local disable = {
  filetypes = {
    '^NvimTree$',
    '^packer$',
    '^startify$',
    '^fugitive$',
    '^fugitiveblame$',
    '^qf$',
    '^help$',
    '^minimap$',
    '^Trouble$',
    '^dap-repl$',
    '^dapui_watches$',
    '^dapui_stacks$',
    '^dapui_breakpoints$',
    '^dapui_scopes$'
  },
  buftypes = {
    '^terminal$'
  },
  bufnames = {}
}

local gruvbox = require('lualine.themes.gruvbox_dark')
local lualine = require('lualine')
lualine.setup({
  theme = gruvbox,
  disable = disable
})
