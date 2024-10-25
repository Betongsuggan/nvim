{ pkgs, src }:
pkgs.vimUtils.buildVimPlugin {
  name = "instant";
  inherit src;
}
