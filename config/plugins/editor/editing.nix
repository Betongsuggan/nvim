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
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          # golines runs gofumpt itself (--base-formatter)
          go = [ "golines" ];
          kotlin = [ "ktfmt" ];
          # Formatted by their language server (lsp_format fallback)
          rust = [ ];
          typescript = [ ];
          typescriptreact = [ ];
          javascript = [ ];
          javascriptreact = [ ];
          # Trailing spaces are line breaks in markdown
          markdown = [ ];
          # Everything without a formatter of its own
          "_" = [ "trim_whitespace" ];
        };
        default_format_opts.lsp_format = "fallback";
        format_on_save.timeout_ms = 2000;
        formatters = {
          stylua.prepend_args = [
            "--indent-type"
            "Spaces"
            "--indent-width"
            "2"
          ];
          nixfmt.prepend_args = [
            "--width"
            "80"
          ];
          golines.prepend_args = [
            "--max-len=120"
            "--base-formatter=gofumpt"
          ];
        };
      };
    };
  };
}
