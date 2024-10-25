{ pkgs }:
let
  configuration = import ../config { inherit pkgs; };
  plugins = import ../plugins { inherit pkgs; };
in 
pkgs.wrapNeovim pkgs.neovim {
  configure = {
    customRC = configuration;
    packages.all.start = plugins;
  };
}
