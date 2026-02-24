# Treesitter syntax highlighting configuration
{ ... }: {
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight = { enable = true; };
      indent = { enable = true; };
      ensure_installed = [
        "go"
        "gomod"
        "gosum"
        "typescript"
        "tsx"
        "javascript"
        "lua"
        "nix"
        "bash"
        "json"
        "yaml"
        "markdown"
        "rust"
        "toml"
        "ron"
      ];
    };
  };
}
