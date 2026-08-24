# Custom floating side-by-side diff viewer; implementation lives in
# lua/config/floating_diff.lua (shipped via extraFiles in default.nix and
# require'd lazily on keypress).
{ ... }:
{
  keymaps = [
    {
      mode = "n";
      key = "<leader>gd";
      action = {
        __raw = "function() require('config.floating_diff').diff('HEAD') end";
      };
      options = {
        desc = "Diff current file vs HEAD (float)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = {
        __raw = "function() require('config.floating_diff').prompt() end";
      };
      options = {
        desc = "Diff current file vs <ref> (float)";
        silent = true;
      };
    }
  ];
}
