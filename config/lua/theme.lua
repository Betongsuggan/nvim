local gruvbox = require("gruvbox")

-- William Theme
--local backgroundLight = "#191b1d"
--local backgroundDark  = "#111213"
--local borderLight     = "#5e5f60"
--local borderDark      = "#111213"
--local textLight       = "#ffffff"
--local textMid         = "#acacac"
--local textDark        = "#161516"
--local yellowLight     = "#f1f252"
--local yellowDark      = "#1c1d16"
--local redLight        = "#ff5151"
--local redDark         = "#1d1516"
--local organgeLight    = "#71e59f"
--local organgeDark     = "#1d1a17"
--local purpleLight     = "#7f71e5"
--local purpleDark      = "#1f2027"
--local blueLight       = "#71e59f"
--local blueDark        = "#151a1e"
--local greenLight      = "#71e59f"
--local greenDark       = "#151c1a"

gruvbox.setup({
  palette_overrides = {},
  overrides = {
    SignColumn = { bg = "#282828" },
    DiagnosticSignError = { bg = "#282828" },
    DiagnosticSignWarn = { bg = "#282828" },
    DiagnosticSignHint = { bg = "#282828" },
    DiagnosticSignInfo = { bg = "#282828" },
    NvimTreeSignColumn = { bg = "#3c3836" },

    DiagnosticVirtualTextError = { bg = "#3c1f1e", fg = "#fb4934" },
    DiagnosticVirtualTextWarn = { bg = "#3a3212", fg = "#fabd2f" },
    DiagnosticVirtualTextInfo = { bg = "#2e3b3b", fg = "#83a598" },
    DiagnosticVirtualTextHint = { bg = "#2d3a2e", fg = "#8ec07c" },
  }
})

vim.cmd.colorscheme("gruvbox")
