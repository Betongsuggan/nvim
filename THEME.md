# Theme Configuration

This Neovim configuration supports multiple popular themes with centralized color management.

## Available Themes

- **catppuccin**: Modern, soothing pastel theme (default) 🎨
- **gruvbox**: Retro groove color scheme with earthy tones 🌲
- **tokyonight**: Modern dark theme inspired by Tokyo's neon nights 🌃
- **nord**: Arctic, north-bluish clean and elegant theme ❄️
- **onedark**: Atom's iconic One Dark theme 🌙
- **nightfox**: Highly customizable dark theme with vibrant colors 🦊
- **dracula**: Dark theme inspired by the famous vampire palette 🧛
- **kanagawa**: Beautiful theme inspired by the famous Japanese painting 🏔️
- **rose-pine**: Soho vibes theme with warm, earthy tones 🌹

## Switching Themes

### Dynamic Theme Switching (Recommended)

You can switch themes instantly from within Neovim:

- **`<leader>th`** - Interactive theme picker (shows all available themes)

You can also use Lua commands directly:
```lua
:lua switch_theme('catppuccin')
:lua switch_theme('tokyonight')
:lua switch_theme('dracula')
:lua theme_picker()
:lua get_saved_theme()          -- Show current saved theme
:lua reset_theme_to_default()   -- Reset to nix config default
```

### **Theme Persistence**
Your theme choice is automatically saved and will be restored when you restart Neovim. The theme is stored in your Neovim data directory (`~/.local/share/nvim/theme.txt` on Linux).

### Static Theme Configuration

To permanently change the default theme, edit `config/theme.nix` and change the `currentThemeName` variable:

```nix
# Available: "catppuccin", "gruvbox", "tokyonight", "nord", "onedark", 
#            "nightfox", "dracula", "kanagawa", "rose-pine"
currentThemeName = "catppuccin";
```

Then rebuild your configuration:

```bash
nix build
```

## Theme System

All colors throughout the configuration reference the centralized theme system and update automatically when switching themes:

- **Lualine**: Uses theme name and updates instantly on switch
- **Scrollbar**: All diagnostic and git colors reference theme  
- **Buffer line**: Diagnostic indicators use theme colors and refresh
- **Gitsigns**: Git diff colors from theme with live updates
- **Trouble/Diagnostics**: Error/warn/info/hint colors from theme
- **Neo-tree**: File explorer colors update automatically
- **Telescope**: Border and UI colors match theme

## Adding New Themes

To add a new theme:

1. Add the theme configuration to the `themes` object in `config/theme.nix`
2. Define all required color values in the `colors` object
3. Add the colorscheme configuration in the theme's `colorscheme` object
4. Update the `currentThemeName` options comment

Example theme structure:

```nix
mytheme = {
  name = "mytheme";
  colorscheme = {
    enable = true;
    settings = {
      # Theme-specific settings
    };
  };
  colors = {
    # All required color definitions
    bg = "#000000";
    fg = "#ffffff";
    # ... etc
  };
};
```

## Color Palette

Each theme defines the following colors that are used throughout the configuration:

### Background Colors
- `bg`: Main background
- `bg_alt`: Alternative background  
- `bg_float`: Floating window background

### Foreground Colors
- `fg`: Main foreground text
- `fg_alt`: Alternative/dimmed text

### Accent Colors
- `blue`, `cyan`, `green`, `yellow`, `orange`, `red`, `pink`, `purple`

### UI Colors
- `border`: Window borders and separators
- `selection`: Selected text background
- `search`: Search highlight color

### Git Colors
- `git_add`: Added lines
- `git_change`: Modified lines
- `git_delete`: Deleted lines

### Diagnostic Colors
- `error`: Error messages
- `warn`: Warning messages
- `info`: Info messages
- `hint`: Hint messages