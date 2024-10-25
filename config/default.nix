{ pkgs }:
let
  configDir = pkgs.stdenv.mkDerivation {
    name = "nvim-lua-configs";
    src = ./lua;
    installPhase = ''
      mkdir -p $out/nvim/lua/
      cp -r . $out/nvim/lua/
      #find . -type f -name "*.lua" -exec cp {} $out/ \;
    '';
  };

#  scripts2ConfigFiles = 
#    builtins.map (file: "${configDir}/${file}") (builtins.attrNames (builtins.readDir configDir));
#
#  sourceConfigFiles = files:
#    builtins.concatStringsSep "\n" (builtins.map (file: "luafile ${file}") files);

#in configDir
in {
  luaConfig = "luafile ${configDir}/nvim/lua/init.lua";
  configHome = configDir;
}
