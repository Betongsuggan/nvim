{ pkgs }:
let
  configDir = pkgs.stdenv.mkDerivation {
    name = "nvim-lua-configs";
    src = ./lua;
    installPhase = ''
      mkdir -p $out/nvim/lua/
      cp -r . $out/nvim/lua/
    '';
  };

#in configDir
in {
  luaConfig = "luafile ${configDir}/nvim/lua/init.lua";
  configHome = configDir;
}
