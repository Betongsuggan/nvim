# Language-independent LSP behavior; the servers are in languages.nix and
# are started through Neovim's own vim.lsp.config/vim.lsp.enable, with
# nvim-lspconfig supplying their default commands and root markers.
{ icons, ... }:
{
  plugins.lspconfig.enable = true;

  # Code lenses (run/test/references above functions) where a server offers
  # them, kept current as the buffer changes
  lsp.onAttach = ''
    if client:supports_method("textDocument/codeLens") then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
        buffer = bufnr,
        callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
      })
    end
  '';

  # LSP progress ($/progress, e.g. kotlin-lsp's ~10 s Gradle import) as one
  # updating snacks notification with a spinner
  autoCmd = [
    {
      desc = "Show LSP progress";
      event = "LspProgress";
      callback.__raw = ''
        function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
            id = "lsp_progress",
            title = "LSP",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and "${icons.glyph "f00c"} "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end
      '';
    }
  ];
}
