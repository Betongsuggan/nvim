-- Core configuration module
-- LSP handlers, diagnostics, vim.ui.select

local M = {}

function M.setup()
  -- Global default for every core floating window (hover, signature, code actions,
  -- diagnostic floats, ui.select). Replaces per-call border overrides.
  vim.o.winborder = "rounded"

  vim.diagnostic.config({
    float = {
      source = true,
      header = "",
      prefix = "",
      focusable = false,
      style = "minimal",
    },
    virtual_text = false,
    virtual_lines = { current_line = true },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",  -- nf-fa-times-circle  U+F057
        [vim.diagnostic.severity.WARN]  = "",  -- nf-fa-warning       U+F071
        [vim.diagnostic.severity.INFO]  = "",  -- nf-fa-info-circle   U+F05A
        [vim.diagnostic.severity.HINT]  = "",  -- nf-fa-lightbulb_o   U+F0EB
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- vim.ui.select is provided by snacks.picker (settings.picker.ui_select = true).
  -- vim.ui.input is provided by snacks.input.

  -- Show trailing whitespace and problematic whitespace
  vim.opt.list = true
  vim.opt.listchars = {
    trail = '.',      -- Show trailing spaces
    tab = '  ',       -- Don't show tabs (use spaces consistently)
    nbsp = '_',       -- Show non-breaking spaces
    extends = '>',    -- Show when line continues beyond screen
    precedes = '<'    -- Show when line begins beyond screen
  }

  -- Highlight current line with background but no underline
  vim.opt.cursorlineopt = 'both'  -- Highlight both line and number

  -- Treesitter-aware folding (smarter than indent-based).
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true
  vim.opt.foldcolumn = '0'

  -- Custom fold text function
  function _G.custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)
    local line_count = vim.v.foldend - vim.v.foldstart + 1
    local indent = string.match(line, '^%s*') or ""
    local text = string.gsub(line, '^%s*', "")
    return indent .. '| ' .. text .. ' ... ' .. line_count .. ' lines |'
  end
  vim.opt.foldtext = 'v:lua.custom_fold_text()'

  -- External file change handling
  local file_change_grp = vim.api.nvim_create_augroup("ExternalFileChange", { clear = true })

  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = file_change_grp,
    pattern = "*",
    callback = function()
      if vim.fn.mode() == "c" then return end
      if vim.bo.buftype ~= "" then return end
      if vim.fn.expand("%") == "" then return end
      vim.cmd("checktime")
    end,
    desc = "Check for external file changes",
  })

  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = file_change_grp,
    pattern = "*",
    callback = function()
      vim.notify(
        "File changed on disk. Buffer reloaded: " .. vim.fn.expand("%:."),
        vim.log.levels.WARN,
        { title = "autoread" }
      )
    end,
  })

  vim.api.nvim_create_autocmd("FileChangedShell", {
    group = file_change_grp,
    pattern = "*",
    callback = function()
      vim.notify(
        "CONFLICT: buffer and disk both changed for " .. vim.fn.expand("<afile>:."),
        vim.log.levels.ERROR,
        { title = "autoread" }
      )
    end,
  })

  -- Native LSP restart for the current buffer (replaces lspconfig's :LspRestart).
  -- Stops attached clients, then re-edits the buffer so configured servers re-attach.
  local function restart_lsp(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if vim.tbl_isempty(clients) then
      vim.notify("No LSP clients attached", vim.log.levels.INFO, { title = "LSP" })
      return
    end
    local names = vim.tbl_map(function(c) return c.name end, clients)
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id, true)
    end
    vim.defer_fn(function()
      vim.cmd("edit")
      vim.notify("Restarted LSP: " .. table.concat(names, ", "), vim.log.levels.INFO, { title = "LSP" })
    end, 200)
  end

  vim.api.nvim_create_user_command("LspRestart", function() restart_lsp() end,
    { desc = "Restart LSP clients attached to the current buffer" })

  -- Notify all LSP clients that a watched file changed. Useful after a git
  -- checkout/rebase if the server's own file watcher missed it.
  vim.api.nvim_create_user_command("LspRefresh", function()
    local clients = vim.lsp.get_clients()
    if vim.tbl_isempty(clients) then
      vim.notify("No LSP clients running", vim.log.levels.INFO, { title = "LSP" })
      return
    end
    local file = vim.uri_from_bufnr(0)
    for _, client in ipairs(clients) do
      client:notify("workspace/didChangeWatchedFiles", {
        changes = { { uri = file, type = 2 } },  -- 2 = Changed
      })
    end
    vim.notify("Sent didChangeWatchedFiles to LSP", vim.log.levels.INFO, { title = "LSP" })
  end, { desc = "Notify LSP clients that the current file changed on disk" })

end

return M
