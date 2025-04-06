local nvim_lsp = require("lspconfig")

return function(on_attach, capabilities)
  nvim_lsp.nil_ls.setup({
    filetypes = { "nix" },
    root_dir = nvim_lsp.util.root_pattern("flake.nix", "shell.nix", ".git"),
    capabilities = capabilities,
    settings = {
      ["nil"] = {
        testSetting = 42,
        formatting = {
          command = { "nixpkgs-fmt" },
        },
      },
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      -- Let statix format
      -- client.server_capabilities.document_formatting = false
      -- client.server_capabilities.document_range_formatting = false
    end,
  })
end
