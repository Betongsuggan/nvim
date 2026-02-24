# Toggleterm terminal configuration
{ ... }: {
  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
        width = { __raw = "math.floor(vim.o.columns * 0.8)"; };
        height = { __raw = "math.floor(vim.o.lines * 0.8)"; };
      };
      shell = "bash";
    };
  };
}
