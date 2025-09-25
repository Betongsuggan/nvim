# Theme Configuration

This Neovim configuration supports multiple themes with centralized color management.

## Available Themes

- **catppuccin**: Modern, soothing pastel theme (default)
- **gruvbox**: Retro groove color scheme with earthy tones

## Switching Themes

To switch themes, edit `config/theme.nix` and change the `currentThemeName` variable:

```nix
# Current theme selection - change this to switch themes
currentThemeName = "catppuccin"; # Options: "catppuccin", "gruvbox"
```

Then rebuild your configuration:

```bash
nix build
```

## Theme System

All colors throughout the configuration reference the centralized theme system:

- **Lualine**: Uses theme name and colors automatically
- **Scrollbar**: All diagnostic and git colors reference theme
- **Buffer line**: Diagnostic indicators use theme colors  
- **Gitsigns**: Git diff colors from theme
- **Trouble/Diagnostics**: Error/warn/info/hint colors from theme

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