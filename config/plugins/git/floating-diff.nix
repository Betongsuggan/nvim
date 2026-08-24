# Custom floating side-by-side diff viewer; implementation lives in
# lua/config/floating_diff.lua (shipped via extraFiles in default.nix and
# require'd lazily on keypress).
{ ... }:
let
  inherit (import ../../lib.nix) nmapLua;
in
{
  keymaps = [
    (nmapLua "<leader>gd" "require('config.floating_diff').diff('HEAD')"
      "Diff current file vs HEAD (float)"
    )
    (nmapLua "<leader>gr" "require('config.floating_diff').prompt()"
      "Diff current file vs <ref> (float)"
    )
  ];
}
