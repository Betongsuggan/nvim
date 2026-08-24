# File navigation (file explorer is snacks.explorer, symbol pickers are
# snacks.picker). Aerial is kept only as the symbol provider for the
# lualine breadcrumb (statusline.nix calls aerial.get_location).
{ ... }:
{
  plugins.aerial = {
    enable = true;
    settings = {
      backends = [
        "lsp"
        "treesitter"
        "markdown"
        "asciidoc"
        "man"
      ];
      attach_mode = "window";
      lazy_load = true;
      disable_max_lines = 10000;
      disable_max_size = 2000000;
      filter_kind = [
        "Class"
        "Constructor"
        "Enum"
        "Function"
        "Interface"
        "Module"
        "Method"
        "Struct"
      ];
      open_automatic = false;
      update_events = "TextChanged,InsertLeave";
      lsp = {
        diagnostics_trigger_update = true;
        update_when_errors = true;
        update_delay = 300;
      };
      treesitter = {
        update_delay = 300;
      };
      markdown = {
        update_delay = 300;
      };
    };
  };
}
