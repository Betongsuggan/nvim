# Text editing: pairs, surround, formatting. Commenting is Neovim's own gc.
{ ... }:
{
  plugins = {
    # Bracket and quote pairs (Rust matcher, treesitter-aware)
    blink-pairs.enable = true;

    # ys/cs/ds/S with the default mappings
    nvim-surround.enable = true;

    # Format on save and on <leader>cf, loaded with the first write
    conform-nvim = {
      enable = true;
      lazyLoad.settings = {
        event = "BufWritePre";
        cmd = "ConformInfo";
      };
      settings = {
        # Formatters per filetype: languages.nix. Everything without one
        # (and no language server formatting it) just loses trailing space.
        formatters_by_ft."_" = [ "trim_whitespace" ];
        default_format_opts.lsp_format = "fallback";
        format_on_save.timeout_ms = 2000;
      };
    };
  };
}
