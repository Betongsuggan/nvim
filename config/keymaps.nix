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

    # Project commands (language-agnostic using <leader>p prefix)
    {
      mode = "n";
      key = "<leader>pt";
      action = {
        __raw = ''
          function()
            -- Detect project type and run appropriate test command
            if vim.fn.filereadable("go.mod") == 1 then
              vim.cmd("!go test ./...")
            elseif vim.fn.filereadable("package.json") == 1 then
              vim.cmd("!npm test")
            elseif vim.fn.filereadable("Cargo.toml") == 1 then
              vim.cmd("!cargo test")
            elseif vim.fn.filereadable("Makefile") == 1 then
              vim.cmd("!make test")
            else
              print("No recognized test framework found")
            end
          end
        '';
      };
      options = { desc = "Run tests"; };
    }
    {
      mode = "n";
      key = "<leader>pr";
      action = {
        __raw = ''
          function()
            -- Detect project type and run appropriate run command
            if vim.fn.filereadable("go.mod") == 1 then
              vim.cmd("!go run .")
            elseif vim.fn.filereadable("package.json") == 1 then
              vim.cmd("!npm start")
            elseif vim.fn.filereadable("Cargo.toml") == 1 then
              vim.cmd("!cargo run")
            elseif vim.fn.filereadable("Makefile") == 1 then
              vim.cmd("!make run")
            else
              print("No recognized run command found")
            end
          end
        '';
      };
      options = { desc = "Run project"; };
    }
    {
      mode = "n";
      key = "<leader>pb";
      action = {
        __raw = ''
          function()
            -- Detect project type and run appropriate build command
            if vim.fn.filereadable("go.mod") == 1 then
              vim.cmd("!go build")
            elseif vim.fn.filereadable("package.json") == 1 then
              vim.cmd("!npm run build")
            elseif vim.fn.filereadable("Cargo.toml") == 1 then
              vim.cmd("!cargo build")
            elseif vim.fn.filereadable("Makefile") == 1 then
              vim.cmd("!make build")
            else
              print("No recognized build command found")
            end
          end
        '';
      };
      options = { desc = "Build project"; };
    }
  ];
}