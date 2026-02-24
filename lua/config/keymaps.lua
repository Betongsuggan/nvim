-- Complex keymap functions module
-- Contains functions that are too complex to inline in Nix

local M = {}

-- Close all buffers except current one (preserving terminals)
function M.close_other_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)

      -- Safely get buffer options using new API
      local buf_type = ""
      local buf_filetype = ""
      pcall(function()
        buf_type = vim.bo[buf].buftype
        buf_filetype = vim.bo[buf].filetype
      end)

      -- Skip terminal buffers, special buffer types, and toggleterm
      local is_terminal = buf_type == 'terminal' or
                          buf_name:match('^term://') or
                          buf_filetype == 'toggleterm' or
                          buf_name:match('toggleterm')

      if not is_terminal then
        pcall(vim.api.nvim_buf_delete, buf, {force = false})
      end
    end
  end
end

-- Rename symbol with custom popup UI
function M.rename_symbol()
  local current_name = vim.fn.expand('<cword>')

  -- Create input buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { current_name })

  -- Calculate popup size and position
  local width = math.max(30, string.len(current_name) + 10)
  local height = 1
  local win_opts = {
    relative = "cursor",
    width = width,
    height = height,
    row = 1,
    col = 0,
    style = "minimal",
    border = "rounded",
    title = " Rename Symbol ",
    title_pos = "center"
  }

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Set up the buffer for input
  vim.bo[buf].filetype = "text"
  vim.wo[win].cursorline = false

  -- Position cursor at end of text and start insert mode
  vim.api.nvim_win_set_cursor(win, {1, string.len(current_name)})
  vim.cmd("startinsert!")  -- startinsert! puts cursor at end of line

  -- Set up keymaps for the rename popup
  local function rename_and_close()
    local new_name = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
    vim.api.nvim_win_close(win, true)
    if new_name and new_name ~= current_name and new_name ~= "" then
      vim.lsp.buf.rename(new_name)
    end
  end

  local function close_popup()
    vim.api.nvim_win_close(win, true)
  end

  -- Keymaps for the popup
  vim.keymap.set({"n", "i"}, "<CR>", rename_and_close, { buffer = buf })
  vim.keymap.set("n", "q", close_popup, { buffer = buf })

  -- Smart Escape behavior: insert mode -> normal mode, normal mode -> exit
  vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = buf })  -- Insert to normal mode
  vim.keymap.set("n", "<Esc>", close_popup, { buffer = buf })  -- Normal mode exits

  -- Allow normal vim mode switching behavior
  vim.keymap.set("i", "<C-c>", close_popup, { buffer = buf })  -- Alternative exit from insert
  vim.keymap.set("n", "i", "i", { buffer = buf })  -- Allow entering insert mode
  vim.keymap.set("n", "a", "a", { buffer = buf })  -- Allow append
  vim.keymap.set("n", "A", "A", { buffer = buf })  -- Allow append at end
end

-- Symbol outline with telescope
function M.symbol_outline()
  require('telescope.builtin').lsp_document_symbols({
    prompt_title = "Symbol Outline",
    results_title = "Symbols",
    preview_title = "Preview",
    layout_strategy = "center",
    layout_config = {
      center = {
        width = 0.8,
        height = 0.8,
        preview_cutoff = 40,
      },
    },
    sorting_strategy = "ascending",
    symbols = {
      "Class", "Constructor", "Enum", "Function",
      "Interface", "Module", "Method", "Struct",
      "Variable", "Field", "Property", "Constant"
    },
  })
end

-- Search symbols with word under cursor
function M.search_symbols()
  require('telescope.builtin').lsp_workspace_symbols({
    prompt_title = "Search Symbols",
    results_title = "Symbol Results",
    preview_title = "Preview",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.5,
      },
    },
    sorting_strategy = "ascending",
    query = vim.fn.expand('<cword>'),
  })
end

-- LSP implementations with telescope
function M.lsp_implementations()
  require('telescope.builtin').lsp_implementations({
    show_line = false,
    trim_text = true,
    include_declaration = false,
    include_current_line = false,
    layout_strategy = "horizontal",
    layout_config = {
      preview_width = 0.5,
      horizontal = {
        prompt_position = "top",
      },
    },
    sorting_strategy = "ascending",
    results_title = "Implementations",
    prompt_title = "Search Implementations",
    preview_title = "Preview",
  })
end

-- File explorer with reveal
function M.file_explorer()
  local current_file = vim.fn.expand('%:p')
  if current_file and current_file ~= "" then
    -- If there's a current file, reveal it in neo-tree
    vim.cmd("Neotree toggle reveal")
  else
    -- If no current file, just toggle normally
    vim.cmd("Neotree toggle")
  end
end

-- Project detection helpers
local function detect_project_type()
  if vim.fn.filereadable("go.mod") == 1 then
    return "go"
  elseif vim.fn.filereadable("package.json") == 1 then
    return "node"
  elseif vim.fn.filereadable("Cargo.toml") == 1 then
    return "rust"
  elseif vim.fn.filereadable("Makefile") == 1 then
    return "make"
  end
  return nil
end

-- Run tests based on project type
function M.run_tests()
  local project_type = detect_project_type()
  if project_type == "go" then
    vim.cmd("!go test ./...")
  elseif project_type == "node" then
    vim.cmd("!npm test")
  elseif project_type == "rust" then
    vim.cmd("!cargo test")
  elseif project_type == "make" then
    vim.cmd("!make test")
  else
    print("No recognized test framework found")
  end
end

-- Run project based on project type
function M.run_project()
  local project_type = detect_project_type()
  if project_type == "go" then
    vim.cmd("!go run .")
  elseif project_type == "node" then
    vim.cmd("!npm start")
  elseif project_type == "rust" then
    vim.cmd("!cargo run")
  elseif project_type == "make" then
    vim.cmd("!make run")
  else
    print("No recognized run command found")
  end
end

-- Build project based on project type
function M.build_project()
  local project_type = detect_project_type()
  if project_type == "go" then
    vim.cmd("!go build")
  elseif project_type == "node" then
    vim.cmd("!npm run build")
  elseif project_type == "rust" then
    vim.cmd("!cargo build")
  elseif project_type == "make" then
    vim.cmd("!make build")
  else
    print("No recognized build command found")
  end
end

-- Toggle inlay hints
function M.toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end
end

-- Open diagnostic float
function M.show_diagnostic()
  vim.diagnostic.open_float({
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    focusable = true,
    style = "minimal"
  })
end

-- Enhanced buffer picker using telescope
-- Replaces bufferline with a more powerful telescope-based solution
function M.buffer_picker()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  require('telescope.builtin').buffers({
    prompt_title = "Open Buffers",
    results_title = "Buffers",
    preview_title = "Preview",
    sort_mru = true,  -- Most recently used first
    sort_lastused = true,
    ignore_current_buffer = false,
    show_all_buffers = false,  -- Only show listed buffers
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        width = 0.8,
        height = 0.7,
      },
    },
    sorting_strategy = "ascending",
    attach_mappings = function(prompt_bufnr, map)
      -- Delete buffer with <C-d>
      local delete_buf = function()
        local selection = action_state.get_selected_entry()
        if selection then
          actions.close(prompt_bufnr)
          vim.api.nvim_buf_delete(selection.bufnr, { force = false })
          -- Reopen buffer picker
          vim.defer_fn(function()
            M.buffer_picker()
          end, 50)
        end
      end

      -- Force delete buffer with <C-D> (shift)
      local force_delete_buf = function()
        local selection = action_state.get_selected_entry()
        if selection then
          actions.close(prompt_bufnr)
          vim.api.nvim_buf_delete(selection.bufnr, { force = true })
          vim.defer_fn(function()
            M.buffer_picker()
          end, 50)
        end
      end

      map('n', '<C-d>', delete_buf)
      map('i', '<C-d>', delete_buf)
      map('n', '<C-D>', force_delete_buf)
      map('i', '<C-D>', force_delete_buf)

      return true
    end,
  })
end

-- Quick buffer switch (cycles through buffers in MRU order)
function M.buffer_next()
  vim.cmd('bnext')
end

function M.buffer_prev()
  vim.cmd('bprevious')
end

-- Export keymap functions to global scope for Nix keymaps
function M.setup()
  _G.keymap_close_other_buffers = M.close_other_buffers
  _G.keymap_rename_symbol = M.rename_symbol
  _G.keymap_symbol_outline = M.symbol_outline
  _G.keymap_search_symbols = M.search_symbols
  _G.keymap_lsp_implementations = M.lsp_implementations
  _G.keymap_file_explorer = M.file_explorer
  _G.keymap_run_tests = M.run_tests
  _G.keymap_run_project = M.run_project
  _G.keymap_build_project = M.build_project
  _G.keymap_toggle_inlay_hints = M.toggle_inlay_hints
  _G.keymap_show_diagnostic = M.show_diagnostic
  _G.keymap_buffer_picker = M.buffer_picker
  _G.keymap_buffer_next = M.buffer_next
  _G.keymap_buffer_prev = M.buffer_prev
end

return M
