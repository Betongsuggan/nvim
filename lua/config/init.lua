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

  -- Re-sync git-aware plugins after external git operations. `:checktime`
  -- (above) reloads file contents when the disk changes, but plugin caches
  -- — gitsigns hunks, git-conflict's conflict table, the diffview tab —
  -- are populated from buffer parse events that don't always re-fire on
  -- branch switches done in an outside terminal. This refresh function
  -- nudges each plugin to re-scan.
  local function refresh_git_state(opts)
    opts = opts or {}
    pcall(vim.cmd, "checktime")

    local gs_ok, gitsigns = pcall(require, "gitsigns")
    if gs_ok and gitsigns.refresh then pcall(gitsigns.refresh) end

    -- git-conflict's :GitConflictRefresh re-parses every loaded buffer
    -- and rebuilds the internal conflict table that backs :GitConflictListQf.
    pcall(vim.cmd, "silent! GitConflictRefresh")

    -- :DiffviewRefresh is a no-op if no diffview tab is open.
    pcall(vim.cmd, "silent! DiffviewRefresh")

    if opts.notify then
      vim.notify("Git state refreshed", vim.log.levels.INFO, { title = "Git" })
    end
  end

  local git_refresh_grp = vim.api.nvim_create_augroup("GitRefresh", { clear = true })

  -- FocusGained fires when nvim regains focus from another window — the
  -- most reliable signal that the user just ran git commands externally.
  -- TermClose covers the case where they ran the command in nvim's own
  -- floating terminal (lazygit, raw `git`). DirChanged covers `:cd` /
  -- session switches into another repo.
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "DirChanged" }, {
    group = git_refresh_grp,
    pattern = "*",
    callback = function()
      -- Defer slightly so any in-flight checktime / file reload settles
      -- before we ask plugins to re-scan from disk.
      vim.defer_fn(function() refresh_git_state() end, 100)
    end,
    desc = "Refresh gitsigns/git-conflict/diffview state",
  })

  vim.api.nvim_create_user_command("GitRefresh",
    function() refresh_git_state({ notify = true }) end,
    { desc = "Re-sync git-aware plugins (gitsigns, git-conflict, diffview)" })

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

  -- The JetBrains kotlin-lsp returns goto-definition results for stdlib /
  -- dependency symbols as `jar:///path/to/foo.jar!/inner/Path.kt` URIs.
  -- Neovim doesn't know how to materialize those, so the buffer ends up
  -- empty (0 lines) and any consumer that tries to position the cursor
  -- (snacks.picker preview, native goto-def jump) crashes with
  -- "Invalid cursor line: out of range". This BufReadCmd extracts the
  -- entry from the jar at read time so the buffer has real content.
  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = vim.api.nvim_create_augroup("JarUriRead", { clear = true }),
    pattern = { "jar://*", "zipfile://*" },
    callback = function(args)
      local uri = args.match
      -- Strip "jar:" / "zipfile:" scheme and optional "file://" prefix,
      -- collapse leading slashes. Result: "<absolute-jar-path>!/<inner>".
      local rest = uri:gsub("^jar:", ""):gsub("^zipfile:", ""):gsub("^file://", "")
      rest = rest:gsub("^/+", "/")
      local jar, inner = rest:match("^(.-)!/(.+)$")
      if not jar or not inner then
        vim.notify("Could not parse jar URI: " .. uri, vim.log.levels.ERROR, { title = "jar" })
        return
      end

      local lines = vim.fn.systemlist({ "unzip", "-p", jar, inner })
      if vim.v.shell_error ~= 0 then
        vim.notify(
          "unzip failed for " .. inner .. " in " .. jar,
          vim.log.levels.ERROR,
          { title = "jar" }
        )
        return
      end

      vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
      vim.bo[args.buf].modifiable = false
      vim.bo[args.buf].readonly = true
      vim.bo[args.buf].buftype = "nofile"
      vim.bo[args.buf].swapfile = false
      local ft = vim.filetype.match({ filename = inner })
      if ft then vim.bo[args.buf].filetype = ft end
    end,
    desc = "Read source entries from inside JAR archives (kotlin-lsp goto-def)",
  })

end

return M
