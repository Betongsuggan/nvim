# Every icon the config sets itself, in one table (available to all modules
# as the `icons` argument). Nerd Font glyphs live in the Private Use Area and
# are easily lost by tools that edit these files, so they are written as
# codepoints and decoded here. File, filetype and LSP-kind icons are not
# listed: mini.icons provides those.
let
  glyph = hex: builtins.fromJSON ''"\u${hex}"'';
in
{
  inherit glyph;

  diagnostics = {
    error = glyph "f057"; # nf-fa-times_circle
    warn = glyph "f071"; # nf-fa-warning
    info = glyph "f05a"; # nf-fa-info_circle
    hint = glyph "f0eb"; # nf-fa-lightbulb_o
  };

  git = {
    branch = glyph "e0a0"; # powerline branch
    # Sign column bars (plain Unicode)
    add = "▎";
    change = "▎";
    delete = "▁";
    topdelete = "‾";
    changedelete = "▎";
    untracked = "┆";
  };

  dap = {
    breakpoint = "●";
    condition = "◆";
    rejected = "○";
    log = "◉";
    stopped = "▶";
  };

  # Rounded powerline caps for the statusline
  separators = {
    left = glyph "e0b6";
    right = glyph "e0b4";
  };

  fold = {
    open = "▾";
    closed = "▸";
  };
}
