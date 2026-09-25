# File, filetype and LSP-kind icons for every plugin, from mini.icons'
# defaults; it stands in for nvim-web-devicons so plugins asking for that get
# the same icons.
{ ... }:
{
  plugins.web-devicons.enable = false;

  plugins.mini-icons = {
    enable = true;
    mockDevIcons = true;
  };
}
