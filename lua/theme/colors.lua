-- Theme color definitions
-- This file is the single source of truth for all theme colors
-- Generated/maintained alongside config/theme.nix

local M = {}

M.themes = {
  catppuccin = {
    name = "catppuccin",
    colors = {
      -- Background colors
      bg = "#1e1e2e",
      bg_alt = "#181825",
      bg_float = "#11111b",
      -- Foreground colors
      fg = "#cdd6f4",
      fg_alt = "#bac2de",
      -- Accent colors
      blue = "#89b4fa",
      cyan = "#94e2d5",
      green = "#a6e3a1",
      yellow = "#f9e2af",
      orange = "#fab387",
      red = "#f38ba8",
      pink = "#f5c2e7",
      purple = "#cba6f7",
      -- UI colors
      border = "#585b70",
      selection = "#313244",
      search = "#f9e2af",
      -- Git colors
      git_add = "#a6e3a1",
      git_change = "#f9e2af",
      git_delete = "#f38ba8",
      -- Diagnostic colors
      error = "#f38ba8",
      warn = "#f9e2af",
      info = "#89b4fa",
      hint = "#94e2d5",
    }
  },
  gruvbox = {
    name = "gruvbox",
    colors = {
      -- Background colors
      bg = "#282828",
      bg_alt = "#1d2021",
      bg_float = "#32302f",
      -- Foreground colors
      fg = "#ebdbb2",
      fg_alt = "#d5c4a1",
      -- Accent colors
      blue = "#83a598",
      cyan = "#8ec07c",
      green = "#b8bb26",
      yellow = "#fabd2f",
      orange = "#fe8019",
      red = "#fb4934",
      pink = "#d3869b",
      purple = "#d3869b",
      -- UI colors
      border = "#504945",
      selection = "#3c3836",
      search = "#fabd2f",
      -- Git colors
      git_add = "#b8bb26",
      git_change = "#fabd2f",
      git_delete = "#fb4934",
      -- Diagnostic colors
      error = "#fb4934",
      warn = "#fabd2f",
      info = "#83a598",
      hint = "#8ec07c",
    }
  },
  tokyonight = {
    name = "tokyonight",
    colors = {
      bg = "#1a1b26",
      bg_alt = "#16161e",
      bg_float = "#16161e",
      fg = "#c0caf5",
      fg_alt = "#9aa5ce",
      blue = "#7aa2f7",
      cyan = "#7dcfff",
      green = "#9ece6a",
      yellow = "#e0af68",
      orange = "#ff9e64",
      red = "#f7768e",
      pink = "#bb9af7",
      purple = "#9d7cd8",
      border = "#27283d",
      selection = "#283457",
      search = "#e0af68",
      git_add = "#9ece6a",
      git_change = "#e0af68",
      git_delete = "#f7768e",
      error = "#f7768e",
      warn = "#e0af68",
      info = "#7aa2f7",
      hint = "#7dcfff",
    }
  },
  nord = {
    name = "nord",
    colors = {
      bg = "#2e3440",
      bg_alt = "#3b4252",
      bg_float = "#3b4252",
      fg = "#eceff4",
      fg_alt = "#d8dee9",
      blue = "#5e81ac",
      cyan = "#88c0d0",
      green = "#a3be8c",
      yellow = "#ebcb8b",
      orange = "#d08770",
      red = "#bf616a",
      pink = "#b48ead",
      purple = "#b48ead",
      border = "#4c566a",
      selection = "#434c5e",
      search = "#ebcb8b",
      git_add = "#a3be8c",
      git_change = "#ebcb8b",
      git_delete = "#bf616a",
      error = "#bf616a",
      warn = "#ebcb8b",
      info = "#5e81ac",
      hint = "#88c0d0",
    }
  },
  onedark = {
    name = "onedark",
    colors = {
      bg = "#282c34",
      bg_alt = "#21252b",
      bg_float = "#21252b",
      fg = "#abb2bf",
      fg_alt = "#828997",
      blue = "#61afef",
      cyan = "#56b6c2",
      green = "#98c379",
      yellow = "#e5c07b",
      orange = "#d19a66",
      red = "#e06c75",
      pink = "#c678dd",
      purple = "#c678dd",
      border = "#3e4451",
      selection = "#3e4451",
      search = "#e5c07b",
      git_add = "#98c379",
      git_change = "#e5c07b",
      git_delete = "#e06c75",
      error = "#e06c75",
      warn = "#e5c07b",
      info = "#61afef",
      hint = "#56b6c2",
    }
  },
  nightfox = {
    name = "nightfox",
    colors = {
      bg = "#192330",
      bg_alt = "#131a24",
      bg_float = "#131a24",
      fg = "#cdcecf",
      fg_alt = "#aeafb0",
      blue = "#719cd6",
      cyan = "#63cdcf",
      green = "#81b29a",
      yellow = "#dbc074",
      orange = "#f4a261",
      red = "#c94f6d",
      pink = "#d67ad2",
      purple = "#9d79d6",
      border = "#2b3b51",
      selection = "#2b3b51",
      search = "#dbc074",
      git_add = "#81b29a",
      git_change = "#dbc074",
      git_delete = "#c94f6d",
      error = "#c94f6d",
      warn = "#dbc074",
      info = "#719cd6",
      hint = "#63cdcf",
    }
  },
  dracula = {
    name = "dracula",
    colors = {
      bg = "#282a36",
      bg_alt = "#21222c",
      bg_float = "#21222c",
      fg = "#f8f8f2",
      fg_alt = "#6272a4",
      blue = "#8be9fd",
      cyan = "#8be9fd",
      green = "#50fa7b",
      yellow = "#f1fa8c",
      orange = "#ffb86c",
      red = "#ff5555",
      pink = "#ff79c6",
      purple = "#bd93f9",
      border = "#44475a",
      selection = "#44475a",
      search = "#f1fa8c",
      git_add = "#50fa7b",
      git_change = "#f1fa8c",
      git_delete = "#ff5555",
      error = "#ff5555",
      warn = "#f1fa8c",
      info = "#8be9fd",
      hint = "#8be9fd",
    }
  },
  kanagawa = {
    name = "kanagawa",
    colors = {
      bg = "#1f1f28",
      bg_alt = "#16161d",
      bg_float = "#16161d",
      fg = "#dcd7ba",
      fg_alt = "#c8c093",
      blue = "#7e9cd8",
      cyan = "#7fb4ca",
      green = "#98bb6c",
      yellow = "#e6c384",
      orange = "#ffa066",
      red = "#c34043",
      pink = "#d27e99",
      purple = "#957fb8",
      border = "#54546d",
      selection = "#2d4f67",
      search = "#e6c384",
      git_add = "#98bb6c",
      git_change = "#e6c384",
      git_delete = "#c34043",
      error = "#c34043",
      warn = "#e6c384",
      info = "#7e9cd8",
      hint = "#7fb4ca",
    }
  },
  ["rose-pine"] = {
    name = "rose-pine",
    colors = {
      bg = "#191724",
      bg_alt = "#1f1d2e",
      bg_float = "#1f1d2e",
      fg = "#e0def4",
      fg_alt = "#908caa",
      blue = "#9ccfd8",
      cyan = "#9ccfd8",
      green = "#31748f",
      yellow = "#f6c177",
      orange = "#f6c177",
      red = "#eb6f92",
      pink = "#eb6f92",
      purple = "#c4a7e7",
      border = "#403d52",
      selection = "#403d52",
      search = "#f6c177",
      git_add = "#31748f",
      git_change = "#f6c177",
      git_delete = "#eb6f92",
      error = "#eb6f92",
      warn = "#f6c177",
      info = "#9ccfd8",
      hint = "#9ccfd8",
    }
  },
}

-- Get a theme by name
function M.get(name)
  return M.themes[name]
end

-- Get all available theme names
function M.available()
  local names = {}
  for name, _ in pairs(M.themes) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

return M
