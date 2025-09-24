{ ... }: {
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
  ];

  # Basic nixvim configuration
  viAlias = true;
  vimAlias = true;
  
  # Colorscheme
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      transparent_background = false;
    };
  };
}