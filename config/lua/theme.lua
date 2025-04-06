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

    -- NvimTree highlights
    NvimTreeSignColumn = { bg = "#282828" },
    NvimTreeNormal = { bg = "#282828" },
    NvimTreeNormalNC = { bg = "#282828" },
    NvimTreeEndOfBuffer = { bg = "#282828" },
    NvimTreeVertSplit = { bg = "#282828", fg = "#3c3836" },
    NvimTreeWinSeparator = { bg = "#282828", fg = "#3c3836" },
    NvimTreeCursorLine = { bg = "#32302f" },
    NvimTreeStatusLine = { bg = "#282828" },
    NvimTreeStatusLineNC = { bg = "#282828" },
    NvimTreeWindowPicker = { bg = "#282828", fg = "#d79921" },

    -- Notify highlights
    NotifyBackground = { bg = "#282828" },
    NotifyERRORBorder = { fg = "#fb4934", bg = "#282828" },
    NotifyWARNBorder = { fg = "#fabd2f", bg = "#282828" },
    NotifyINFOBorder = { fg = "#83a598", bg = "#282828" },
    NotifyDEBUGBorder = { fg = "#8ec07c", bg = "#282828" },
    NotifyTRACEBorder = { fg = "#d3869b", bg = "#282828" },
    NotifyERRORIcon = { fg = "#fb4934" },
    NotifyWARNIcon = { fg = "#fabd2f" },
    NotifyINFOIcon = { fg = "#83a598" },
    NotifyDEBUGIcon = { fg = "#8ec07c" },
    NotifyTRACEIcon = { fg = "#d3869b" },
    NotifyERRORTitle = { fg = "#fb4934", bold = true },
    NotifyWARNTitle = { fg = "#fabd2f", bold = true },
    NotifyINFOTitle = { fg = "#83a598", bold = true },
    NotifyDEBUGTitle = { fg = "#8ec07c", bold = true },
    NotifyTRACETitle = { fg = "#d3869b", bold = true },
    NotifyERRORBody = { bg = "#282828" },
    NotifyWARNBody = { bg = "#282828" },
    NotifyINFOBody = { bg = "#282828" },
    NotifyDEBUGBody = { bg = "#282828" },
    NotifyTRACEBody = { bg = "#282828" },

    -- Fidget highlights
    FidgetTitle = { fg = "#d79921", bold = true },
    FidgetWindow = { bg = "#282828" },
    FidgetTask = { bg = "#282828", fg = "#a89984" },
    FidgetNormal = { bg = "#282828" },
    FidgetProgress = { fg = "#83a598" },
    FidgetDone = { fg = "#b8bb26" },

    DiagnosticVirtualTextError = { bg = "#3c1f1e", fg = "#fb4934" },
    DiagnosticVirtualTextWarn = { bg = "#3a3212", fg = "#fabd2f" },
    DiagnosticVirtualTextInfo = { bg = "#2e3b3b", fg = "#83a598" },
    DiagnosticVirtualTextHint = { bg = "#2d3a2e", fg = "#8ec07c" },
  },
})

vim.cmd.colorscheme("gruvbox")
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#282828" })
