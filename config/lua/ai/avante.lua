require("avante_lib").load()
local keymaps = require("editor/keymappings")
local avante = require("avante")

avante.setup({
  windows = {
    ---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
    position = "right",
    wrap = true,
    width = 30, -- default % based on available width in vertical layout
    height = 30, -- default % based on available height in horizontal layout
    sidebar_header = {
      enabled = true, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8, -- Height of the input window in vertical layout
    },
    edit = {
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = true, -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window
      ---@alias AvanteInitialDiff "ours" | "theirs"
      focus_on_apply = "ours", -- which diff to focus after applying
    },
  },
  highlight = {
    normal = "Normal",
    border = "FloatBorder",
    title = "Title",
  },
})

keymaps.ai_complete(function()
  avante.get_suggestion():suggest()
end)
