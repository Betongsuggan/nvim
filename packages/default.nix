{ pkgs }:
let
  plugins = import ../plugins { inherit pkgs; };
  configuration = import ../config { inherit pkgs; };
  dependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = plugins.runtimeDependencies;
  };
  neovim = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      customRC = configuration;
      packages.all.start = plugins.vimPlugins;
    };
  };
in pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ dependencies ];
  text = ''
    ${neovim}/bin/nvim "$@"
  '';
}
