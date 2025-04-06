-- Setup lspconfig.
local telescope = require("telescope.builtin")
local keymaps = require("editor/keymappings")
local languages = require("lsp/servers")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require("illuminate").on_attach(client)

  -- Adds keymappings for common lsp functions
  keymaps.lsp_go_to_declaration(telescope.lsp_type_definitions)
  keymaps.lsp_go_to_definition(telescope.lsp_definitions)
  keymaps.lsp_go_to_implementation(telescope.lsp_implementations)

  keymaps.lsp_next_reference(function()
    require("illuminate").next_reference({ wrap = true })
  end)
  keymaps.lsp_previous_reference(function()
    require("illuminate").next_reference({ reverse = true, wrap = true })
  end)

  keymaps.lsp_next_diagnostic(function()
    vim.diagnostic.goto_next({float = {border = "rounded"}})
  end)
  keymaps.lsp_previous_diagnostic(function()
    vim.diagnostic.goto_prev({float = {border = "rounded"}})
  end)

  keymaps.lsp_hover(function()
    vim.lsp.buf.hover({ border = "rounded" })
  end)

  keymaps.lsp_rename(vim.lsp.buf.rename)
  keymaps.lsp_format(vim.lsp.buf.format)
  keymaps.lsp_show_signature(vim.lsp.buf.signature_help)
  keymaps.lsp_show_type_definition(vim.lsp.buf.type_definition)
  keymaps.lsp_show_code_action(require("actions-preview").code_actions)
  keymaps.lsp_show_diagnostics(function()
    vim.diagnostic.open_float({ border = "rounded" })
  end)
  keymaps.lsp_show_references(telescope.lsp_references)
  keymaps.lsp_create_workspace(vim.lsp.buf.add_workspace_folder)
  keymaps.lsp_remove_workspace(vim.lsp.buf.remove_workspace_folder)
  keymaps.lsp_show_workspaces(function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, language in ipairs(languages) do
  language(on_attach, capabilities)
end
