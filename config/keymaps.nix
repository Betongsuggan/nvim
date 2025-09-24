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
      key = "<leader>qq";
      action = "<cmd>q<CR>";
      options = { desc = "Quit"; };
    }

    # Buffer management
    {
      mode = "n";
      key = "<leader>bs";
      action = "<cmd>w<CR>";
      options = { desc = "Save buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<CR>";
      options = { desc = "Delete buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bD";
      action = "<cmd>bdelete!<CR>";
      options = { desc = "Force delete buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = {
        __raw = "function() vim.cmd('%bdelete|edit#|bdelete#') end";
      };
      options = { desc = "Close all other buffers"; };
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
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>bnext<CR>";
      options = { desc = "Next buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>bprevious<CR>";
      options = { desc = "Previous buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bc";
      action = {
        __raw = "function() require('bufferline').pick_buffer() end";
      };
      options = { desc = "Pick buffer to switch to"; };
    }

    # Window management
    {
      mode = "n";
      key = "<leader>wv";
      action = "<cmd>vsplit<CR>";
      options = { desc = "Split window vertically"; };
    }
    {
      mode = "n";
      key = "<leader>wh";
      action = "<cmd>split<CR>";
      options = { desc = "Split window horizontally"; };
    }
    {
      mode = "n";
      key = "<leader>wc";
      action = "<cmd>close<CR>";
      options = { desc = "Close window"; };
    }
    {
      mode = "n";
      key = "<leader>wo";
      action = "<cmd>only<CR>";
      options = { desc = "Close all other windows"; };
    }
    {
      mode = "n";
      key = "<leader>ww";
      action = "<C-w>w";
      options = { desc = "Switch to next window"; };
    }
    {
      mode = "n";
      key = "<leader>wr";
      action = "<C-w>r";
      options = { desc = "Rotate windows"; };
    }

    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = { desc = "Move to left window"; };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = { desc = "Move to bottom window"; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = { desc = "Move to top window"; };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = { desc = "Move to right window"; };
    }

    # Window resizing
    {
      mode = "n";
      key = "<leader>w=";
      action = "<C-w>=";
      options = { desc = "Equalize window sizes"; };
    }
    {
      mode = "n";
      key = "<leader>w+";
      action = "<cmd>resize +5<CR>";
      options = { desc = "Increase window height"; };
    }
    {
      mode = "n";
      key = "<leader>w-";
      action = "<cmd>resize -5<CR>";
      options = { desc = "Decrease window height"; };
    }
    {
      mode = "n";
      key = "<leader>w>";
      action = "<cmd>vertical resize +5<CR>";
      options = { desc = "Increase window width"; };
    }
    {
      mode = "n";
      key = "<leader>w<";
      action = "<cmd>vertical resize -5<CR>";
      options = { desc = "Decrease window width"; };
    }

    # Find operations (using <leader>f prefix - Telescope)
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Neotree toggle<CR>";
      options = { desc = "File explorer"; };
    }
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

    # LSP keymaps (all under <leader>l prefix to avoid vim conflicts)
    {
      mode = "n";
      key = "<leader>ld";
      action = {
        __raw = "function() require('telescope.builtin').lsp_definitions() end";
      };
      options = { desc = "LSP definitions"; };
    }
    {
      mode = "n";
      key = "<leader>lD";
      action = {
        __raw = "function() vim.lsp.buf.declaration() end";
      };
      options = { desc = "LSP declaration"; };
    }
    {
      mode = "n";
      key = "<leader>li";
      action = {
        __raw = "function() require('telescope.builtin').lsp_implementations() end";
      };
      options = { desc = "LSP implementations"; };
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = {
        __raw = "function() require('telescope.builtin').lsp_references() end";
      };
      options = { desc = "LSP references"; };
    }
    {
      mode = "n";
      key = "<leader>lh";
      action = {
        __raw = "function() vim.lsp.buf.hover() end";
      };
      options = { desc = "LSP hover info"; };
    }
    {
      mode = "n";
      key = "<leader>ln";
      action = {
        __raw = "function() vim.lsp.buf.rename() end";
      };
      options = { desc = "LSP rename"; };
    }
    {
      mode = "n";
      key = "<leader>la";
      action = {
        __raw = "function() vim.lsp.buf.code_action() end";
      };
      options = { desc = "LSP code action"; };
    }
    {
      mode = "n";
      key = "<leader>lf";
      action = {
        __raw = "function() vim.lsp.buf.format() end";
      };
      options = { desc = "LSP format"; };
    }

    # Diagnostic keymaps
    {
      mode = "n";
      key = "[d";
      action = {
        __raw = "function() vim.diagnostic.goto_prev() end";
      };
      options = { desc = "Previous diagnostic"; };
    }
    {
      mode = "n";
      key = "]d";
      action = {
        __raw = "function() vim.diagnostic.goto_next() end";
      };
      options = { desc = "Next diagnostic"; };
    }
    {
      mode = "n";
      key = "<leader>le";
      action = {
        __raw = "function() vim.diagnostic.open_float() end";
      };
      options = { desc = "LSP show diagnostic"; };
    }

    # Git hunk navigation and actions
    {
      mode = "n";
      key = "]h";
      action = {
        __raw = "function() require('gitsigns').next_hunk() end";
      };
      options = { desc = "Next git hunk"; };
    }
    {
      mode = "n";
      key = "[h";
      action = {
        __raw = "function() require('gitsigns').prev_hunk() end";
      };
      options = { desc = "Previous git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = {
        __raw = "function() require('gitsigns').preview_hunk() end";
      };
      options = { desc = "Preview git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = {
        __raw = "function() require('gitsigns').stage_hunk() end";
      };
      options = { desc = "Stage git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gu";
      action = {
        __raw = "function() require('gitsigns').undo_stage_hunk() end";
      };
      options = { desc = "Undo stage git hunk"; };
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