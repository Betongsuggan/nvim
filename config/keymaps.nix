{ ... }: {
  keymaps = [
    # General editor keymaps
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = { desc = "Clear search highlights"; };
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options = { desc = "Save file"; };
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>q<CR>";
      options = { desc = "Quit"; };
    }

    # Buffer navigation
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bd<CR>";
      options = { desc = "Delete buffer"; };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<CR>";
      options = { desc = "Previous buffer"; };
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<CR>";
      options = { desc = "Next buffer"; };
    }

    # Find operations (using <leader>f prefix - Telescope)
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options = { desc = "Find files"; };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options = { desc = "Find by grep"; };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options = { desc = "Find buffers"; };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options = { desc = "Find help"; };
    }

    # LSP keymaps
    {
      mode = "n";
      key = "gd";
      action = "vim.lsp.buf.definition";
      options = { desc = "Go to definition"; };
    }
    {
      mode = "n";
      key = "gD";
      action = "vim.lsp.buf.declaration";
      options = { desc = "Go to declaration"; };
    }
    {
      mode = "n";
      key = "gi";
      action = "vim.lsp.buf.implementation";
      options = { desc = "Go to implementation"; };
    }
    {
      mode = "n";
      key = "gr";
      action = "vim.lsp.buf.references";
      options = { desc = "Show references"; };
    }
    {
      mode = "n";
      key = "K";
      action = "vim.lsp.buf.hover";
      options = { desc = "Show hover documentation"; };
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = "vim.lsp.buf.rename";
      options = { desc = "LSP rename"; };
    }
    {
      mode = "n";
      key = "<leader>la";
      action = "vim.lsp.buf.code_action";
      options = { desc = "LSP code action"; };
    }
    {
      mode = "n";
      key = "<leader>lf";
      action = "vim.lsp.buf.format";
      options = { desc = "LSP format"; };
    }

    # Diagnostic keymaps
    {
      mode = "n";
      key = "[d";
      action = "vim.diagnostic.goto_prev";
      options = { desc = "Previous diagnostic"; };
    }
    {
      mode = "n";
      key = "]d";
      action = "vim.diagnostic.goto_next";
      options = { desc = "Next diagnostic"; };
    }
    {
      mode = "n";
      key = "<leader>ld";
      action = "vim.diagnostic.open_float";
      options = { desc = "LSP show diagnostic"; };
    }

    # Go-specific keymaps (using <leader>g prefix for Go commands)
    {
      mode = "n";
      key = "<leader>grt";
      action = "<cmd>!go test ./...<CR>";
      options = { desc = "Go run tests"; };
    }
    {
      mode = "n";
      key = "<leader>grr";
      action = "<cmd>!go run .<CR>";
      options = { desc = "Go run main"; };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>!go build<CR>";
      options = { desc = "Go build"; };
    }
  ];
}