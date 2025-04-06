local nvim_lsp = require('lspconfig')
local keymaps  = require('editor/keymappings')

return function(on_attach, capabilities)
  local function ts_on_attach(client, bufnr)
    on_attach(client, bufnr)
    keymaps.lsp_format(function()
      vim.cmd "PrettierAsync"
    end)
  end

  nvim_lsp.ts_ls.setup {
    on_attach = ts_on_attach,
    capabilities = capabilities,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
    root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  }
end
