-- Core configuration module
-- LSP handlers, diagnostics, vim.ui.select

local M = {}

function M.setup()
  -- Configure LSP floating windows with rounded borders
  local border_opts = {
    border = "rounded",
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
  }

  -- LSP hover/signature_help with rounded borders (replaces deprecated vim.lsp.with)
  vim.lsp.buf.hover = (function(orig)
    return function(config)
      config = vim.tbl_extend("force", { border = "rounded", focusable = true }, config or {})
      return orig(config)
    end
  end)(vim.lsp.buf.hover)

  vim.lsp.buf.signature_help = (function(orig)
    return function(config)
      config = vim.tbl_extend("force", { border = "rounded", focusable = false }, config or {})
      return orig(config)
    end
  end)(vim.lsp.buf.signature_help)

  -- Diagnostic configuration with rounded borders and emoji signs
  vim.diagnostic.config({
    float = {
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      focusable = false,
      style = "minimal",
    },
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "~",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",  -- nf-fa-times-circle  U+F057
        [vim.diagnostic.severity.WARN]  = "",  -- nf-fa-warning       U+F071
        [vim.diagnostic.severity.INFO]  = "",  -- nf-fa-info-circle   U+F05A
        [vim.diagnostic.severity.HINT]  = "",  -- nf-fa-lightbulb_o   U+F0EB
      },
    },
    underline = true,
    update_in_insert = false,  -- Disabled for performance with many buffers
    severity_sort = true,
  })

  -- Define diagnostic signs for the signcolumn
  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn",  { text = "", texthl = "DiagnosticSignWarn"  })
  vim.fn.sign_define("DiagnosticSignInfo",  { text = "", texthl = "DiagnosticSignInfo"  })
  vim.fn.sign_define("DiagnosticSignHint",  { text = "", texthl = "DiagnosticSignHint"  })

  -- Additional LSP window configuration
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  -- Use telescope for code actions instead of custom ui.select
  local has_telescope, telescope = pcall(require, 'telescope')
  if has_telescope then
    vim.ui.select = function(items, opts, on_choice)
      if opts and opts.format_item then
        -- Use format_item if provided by LSP
        local formatted_items = {}
        for i, item in ipairs(items) do
          formatted_items[i] = opts.format_item(item)
        end
        require('telescope.pickers').new({}, {
          prompt_title = opts.prompt or "Code Actions",
          finder = require('telescope.finders').new_table {
            results = formatted_items,
          },
          sorter = require('telescope.config').values.generic_sorter({}),
          layout_strategy = "cursor",
          layout_config = {
            cursor = {
              width = 60,
              height = 15,
            }
          },
          attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')

            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              if selection then
                on_choice(items[selection.index], selection.index)
              else
                on_choice(nil, nil)
              end
            end)

            return true
          end,
        }):find()
      else
        -- Fallback to simple floating window
        local choices = {}
        for i, item in ipairs(items) do
          choices[i] = string.format("%d: %s", i, tostring(item))
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, choices)

        local width = 60
        local height = math.min(#choices, 15)
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "cursor",
          width = width,
          height = height,
          row = 1,
          col = 0,
          style = "minimal",
          border = "rounded"
        })
        vim.wo[win].cursorline = true

        local function select_and_close(index)
          vim.api.nvim_win_close(win, true)
          if index and index > 0 and index <= #items then
            on_choice(items[index], index)
          else
            on_choice(nil, nil)
          end
        end

        for i = 1, math.min(#items, 9) do
          vim.keymap.set("n", tostring(i), function() select_and_close(i) end, { buffer = buf })
        end
        vim.keymap.set("n", "<CR>", function()
          local line = vim.api.nvim_win_get_cursor(win)[1]
          select_and_close(line)
        end, { buffer = buf })
        vim.keymap.set("n", "<Esc>", function() select_and_close(nil) end, { buffer = buf })
        vim.keymap.set("n", "q", function() select_and_close(nil) end, { buffer = buf })
      end
    end
  end

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

  -- Enhanced folding with custom markers
  vim.opt.foldmethod = 'indent'
  vim.opt.foldlevel = 99  -- Start with all folds open
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true
  vim.opt.foldcolumn = '0'  -- Hide fold column

  -- Custom fold text function
  function _G.custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)
    local line_count = vim.v.foldend - vim.v.foldstart + 1
    local indent = string.match(line, '^%s*') or ""
    local text = string.gsub(line, '^%s*', "")
    return indent .. '| ' .. text .. ' ... ' .. line_count .. ' lines |'
  end
  vim.opt.foldtext = 'v:lua.custom_fold_text()'

  -- Integrate autopairs with cmp (with proper loading check)
  vim.defer_fn(function()
    local ok_cmp, cmp = pcall(require, 'cmp')
    local ok_autopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    if ok_cmp and ok_autopairs then
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  end, 100)

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

  -- Enhanced telescope diagnostics function
  local function telescope_diagnostics_with_preview()
    require('telescope.builtin').diagnostics({
      previewer = true,
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 0.5,
        horizontal = {
          prompt_position = "top",
        },
      },
      sorting_strategy = "ascending",
      results_title = "Diagnostics",
      prompt_title = "Search Diagnostics",
      preview_title = "Preview",
    })
  end

  _G.telescope_diagnostics_with_preview = telescope_diagnostics_with_preview
end

return M
