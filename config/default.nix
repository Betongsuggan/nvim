{ pkgs }:
let
  configDir = pkgs.stdenv.mkDerivation {
    name = "nvim-lua-configs";
    src = ./lua;
    installPhase = ''
      mkdir -p $out/
      #find ./ -type f -exec cp --parents {} $out/ \;
      cp -r ./* $out/
    '';
  };

in "luafile ${configDir}/init.lua"
