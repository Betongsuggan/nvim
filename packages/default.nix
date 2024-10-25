{ pkgs }:
let
  plugins = import ../plugins { inherit pkgs; };
  configuration = import ../config { inherit pkgs; };
  dependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = plugins.runtimeDependencies;
  };
  neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      customRC = configuration.luaConfig;
      packages.all.start = plugins.vimPlugins;
    };
  };
in pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ dependencies ];
  text = ''
    env XDG_CONFIG_HOME=${configuration.configHome} ${neovim}/bin/nvim "$@"
  '';
}
