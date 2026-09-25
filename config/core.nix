# Editor behavior: options, diagnostics, clipboard and the few autocommands
# that aren't a plugin's.
{ icons, ... }:
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  opts = {
    # Line numbers and UI
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    cursorline = true;
    cursorlineopt = "both";
    colorcolumn = "120";
    # Every core floating window (hover, signature, diagnostics, ui.select)
    winborder = "rounded";

    # Indentation
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    autoindent = true;
    smartindent = true;

    # Search
    ignorecase = true;
    smartcase = true;

    # Behavior
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    mouse = "a";
    clipboard = "unnamedplus";
    updatetime = 1000;
    timeoutlen = 300;

    # Files
    backup = false;
    writebackup = false;
    swapfile = false;
    undofile = true;
    autoread = true;

    # Show trailing and non-breaking spaces, not tabs
    list = true;
    listchars = {
      trail = ".";
      tab = "  ";
      nbsp = "_";
      extends = ">";
      precedes = "<";
    };

    # Folds (treesitter provides foldexpr): all open, and a folded line keeps
    # its own syntax highlighting
    foldlevel = 99;
    foldlevelstart = 99;
    foldcolumn = "0";
    foldtext = "";
    fillchars = {
      fold = " ";
      foldopen = icons.fold.open;
      foldclose = icons.fold.closed;
    };
  };

  diagnostic.settings = {
    virtual_text = false;
    virtual_lines.current_line = true;
    underline = true;
    update_in_insert = false;
    severity_sort = true;
    float = {
      source = true;
      header = "";
      prefix = "";
      style = "minimal";
    };
    signs.text = {
      __raw = ''
        {
          [vim.diagnostic.severity.ERROR] = "${icons.diagnostics.error}",
          [vim.diagnostic.severity.WARN] = "${icons.diagnostics.warn}",
          [vim.diagnostic.severity.INFO] = "${icons.diagnostics.info}",
          [vim.diagnostic.severity.HINT] = "${icons.diagnostics.hint}",
        }
      '';
    };
  };

  # Over SSH there is no local clipboard tool for `clipboard=unnamedplus`, so
  # yanks go to the local terminal through OSC 52.
  extraConfigLuaPre = ''
    if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
      local osc52 = require("vim.ui.clipboard.osc52")
      local function paste()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end
      vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
        paste = { ["+"] = paste, ["*"] = paste },
      }
    end
  '';

  autoGroups.core.clear = true;
  autoCmd = [
    {
      desc = "Briefly highlight yanked text";
      event = "TextYankPost";
      group = "core";
      callback.__raw = "function() vim.hl.on_yank() end";
    }
    {
      # autoread only acts when Neovim checks; returning to the editor is when
      # files usually changed underneath it (git, formatters, other editors)
      desc = "Reload files changed on disk";
      event = "FocusGained";
      group = "core";
      command = "checktime";
    }
    {
      desc = "Say which buffer was reloaded from disk";
      event = "FileChangedShellPost";
      group = "core";
      callback.__raw = ''
        function()
          vim.notify("Reloaded from disk: " .. vim.fn.expand("%:."), vim.log.levels.WARN)
        end
      '';
    }
  ];

  userCommands.LspRefresh = {
    desc = "Tell every LSP client the current file changed on disk";
    command.__raw = ''
      function()
        local uri = vim.uri_from_bufnr(0)
        for _, client in ipairs(vim.lsp.get_clients()) do
          client:notify("workspace/didChangeWatchedFiles", { changes = { { uri = uri, type = 2 } } })
        end
      end
    '';
  };
}
