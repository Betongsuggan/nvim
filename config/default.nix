{ pkgs, ... }: let
  theme = import ./theme.nix;
in {
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
  ];

  # Basic nixvim configuration
  viAlias = true;
  vimAlias = true;
  
  # Colorscheme from theme
  colorschemes.${theme.name} = theme.colorscheme;

  # Additional packages needed by plugins
  extraPackages = with pkgs; [
    ripgrep # Required by telescope live_grep
    # Nerd Fonts for proper icon display
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    # Debugging tools
    delve # Go debugger
  ];

  # Extra plugins not available in nixvim
  extraPlugins = with pkgs.vimPlugins; [
    nvim-scrollbar

    # Popular colorschemes
    gruvbox-nvim          # Gruvbox - retro groove colors
    tokyonight-nvim       # Tokyo Night - modern dark theme
    nord-nvim             # Nord - arctic, north-bluish theme
    onedark-nvim          # OneDark - Atom's iconic One Dark theme
    nightfox-nvim         # Nightfox - highly customizable theme
    dracula-nvim          # Dracula - dark theme inspired by the famous color palette
    kanagawa-nvim         # Kanagawa - inspired by the famous painting
    rose-pine             # Rosé Pine - soho vibes theme

    # Testing and debugging plugins  
    neotest-go            # Go test adapter for neotest
    neotest-plenary       # Plenary test adapter
  ];

  # Configure nvim-scrollbar with theme colors and theme switching
  # Configuration moved to individual plugin files for better organization
  # - Theme configuration: config/plugins/themes.nix
  # - UI/scrollbar configuration: config/plugins/ui-visual.nix
  # - Test configuration: config/plugins/testing-debug.nix
}
