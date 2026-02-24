-- Core configuration module
-- LSP handlers, diagnostics, vim.ui.select

local M = {}

function M.setup()
  -- Configure LSP floating windows with rounded borders
  local border_opts = {
    border = "rounded",
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
  }

  -- LSP handlers with rounded borders
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    focusable = true,
    style = "minimal",
    source = "always",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    focusable = false,
    style = "minimal",
  })

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
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.INFO] = "I",
        [vim.diagnostic.severity.HINT] = "H",
      },
    },
    underline = true,
    update_in_insert = false,  -- Disabled for performance with many buffers
    severity_sort = true,
  })

  -- Define diagnostic signs for the signcolumn
  vim.fn.sign_define("DiagnosticSignError", {
    text = "E",
    texthl = "DiagnosticSignError"
  })
  vim.fn.sign_define("DiagnosticSignWarn", {
    text = "W",
    texthl = "DiagnosticSignWarn"
  })
  vim.fn.sign_define("DiagnosticSignInfo", {
    text = "I",
    texthl = "DiagnosticSignInfo"
  })
  vim.fn.sign_define("DiagnosticSignHint", {
    text = "H",
    texthl = "DiagnosticSignHint"
  })

  -- Additional LSP window configuration
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  -- Configure code action menu with rounded borders
  vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(
    vim.lsp.handlers["textDocument/codeAction"], {
      border = "rounded",
      focusable = true,
      style = "minimal",
    }
  )

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

  -- Auto-format on save for Nix files
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.nix" },
    callback = function()
      vim.lsp.buf.format()
    end,
  })

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
