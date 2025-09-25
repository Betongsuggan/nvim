# Theme configuration - Pure data only, no nixvim options
let
  # Define available themes
  themes = {
    catppuccin = {
      name = "catppuccin";
      colorscheme = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = false;
        };
      };
      colors = {
        # Background colors
        bg = "#1e1e2e";
        bg_alt = "#181825";
        bg_float = "#11111b";
        
        # Foreground colors
        fg = "#cdd6f4";
        fg_alt = "#bac2de";
        
        # Accent colors
        blue = "#89b4fa";
        cyan = "#94e2d5";
        green = "#a6e3a1";
        yellow = "#f9e2af";
        orange = "#fab387";
        red = "#f38ba8";
        pink = "#f5c2e7";
        purple = "#cba6f7";
        
        # UI colors
        border = "#585b70";
        selection = "#313244";
        search = "#f9e2af";
        
        # Git colors
        git_add = "#a6e3a1";
        git_change = "#f9e2af";
        git_delete = "#f38ba8";
        
        # Diagnostic colors
        error = "#f38ba8";
        warn = "#f9e2af";
        info = "#89b4fa";
        hint = "#94e2d5";
      };
    };
    
    gruvbox = {
      name = "gruvbox";
      colorscheme = {
        enable = true;
        settings = {
          contrast = "medium";
          transparent_mode = false;
        };
      };
      colors = {
        # Background colors
        bg = "#282828";
        bg_alt = "#1d2021";
        bg_float = "#32302f";
        
        # Foreground colors
        fg = "#ebdbb2";
        fg_alt = "#d5c4a1";
        
        # Accent colors
        blue = "#83a598";
        cyan = "#8ec07c";
        green = "#b8bb26";
        yellow = "#fabd2f";
        orange = "#fe8019";
        red = "#fb4934";
        pink = "#d3869b";
        purple = "#d3869b";
        
        # UI colors
        border = "#504945";
        selection = "#3c3836";
        search = "#fabd2f";
        
        # Git colors
        git_add = "#b8bb26";
        git_change = "#fabd2f";
        git_delete = "#fb4934";
        
        # Diagnostic colors
        error = "#fb4934";
        warn = "#fabd2f";
        info = "#83a598";
        hint = "#8ec07c";
      };
    };
  };

  # Current theme selection - change this to switch themes
  # Available: "catppuccin", "gruvbox", "tokyonight", "nord", "onedark", 
  #            "nightfox", "dracula", "kanagawa", "rose-pine"
  currentThemeName = "catppuccin";
  
  # Get current theme configuration
  currentTheme = themes.${currentThemeName};

in {
  # Export theme configuration for use by other modules
  name = currentTheme.name;
  colors = currentTheme.colors;
  colorscheme = currentTheme.colorscheme;
  themes = themes;
}
