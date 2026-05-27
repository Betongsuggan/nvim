-- Keymap helpers that don't have a direct one-liner in keymaps.nix.
-- File explorer, buffer picker, symbol pickers, rename UI are all snacks now —
-- this file only holds project-detection + the close-other-buffers helper.

local M = {}

function M.close_other_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local ok_t, buftype = pcall(function() return vim.bo[buf].buftype end)
      local ok_f, filetype = pcall(function() return vim.bo[buf].filetype end)
      local name = vim.api.nvim_buf_get_name(buf)
      local is_terminal = (ok_t and buftype == "terminal")
        or name:match("^term://")
        or (ok_f and (filetype == "toggleterm" or filetype == "snacks_terminal"))
      if not is_terminal then
        pcall(vim.api.nvim_buf_delete, buf, { force = false })
      end
    end
  end
end

function M.show_diagnostic()
  vim.diagnostic.open_float({
    source = true,
    header = "",
    prefix = "",
    focusable = true,
    style = "minimal",
  })
end

function M.toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

local function detect_project_type()
  if vim.fn.filereadable("go.mod") == 1 then return "go"
  elseif vim.fn.filereadable("package.json") == 1 then return "node"
  elseif vim.fn.filereadable("Cargo.toml") == 1 then return "rust"
  elseif vim.fn.filereadable("Makefile") == 1 then return "make"
  end
  return nil
end

local function run_cmd_for(project, cmds)
  local cmd = cmds[project]
  if cmd then vim.cmd("!" .. cmd) else print("No recognized project type") end
end

function M.run_tests()
  run_cmd_for(detect_project_type(), {
    go = "go test ./...",
    node = "npm test",
    rust = "cargo test",
    make = "make test",
  })
end

function M.run_project()
  run_cmd_for(detect_project_type(), {
    go = "go run .",
    node = "npm start",
    rust = "cargo run",
    make = "make run",
  })
end

function M.build_project()
  run_cmd_for(detect_project_type(), {
    go = "go build",
    node = "npm run build",
    rust = "cargo build",
    make = "make build",
  })
end

function M.setup()
  _G.keymap_close_other_buffers = M.close_other_buffers
  _G.keymap_run_tests = M.run_tests
  _G.keymap_run_project = M.run_project
  _G.keymap_build_project = M.build_project
  _G.keymap_toggle_inlay_hints = M.toggle_inlay_hints
  _G.keymap_show_diagnostic = M.show_diagnostic
end

return M
