vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]

vim.fn.sign_define('LightBulbSign', { text = "💡", texthl = "LightBulbSignColor", linehl = "", numhl = "" })

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "🚨",
      [vim.diagnostic.severity.WARN] = "⚠️ ",
      [vim.diagnostic.severity.INFO] = "💬",
      [vim.diagnostic.severity.HINT] = "💡",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "Error",
      [vim.diagnostic.severity.WARN] = "Warn",
      [vim.diagnostic.severity.INFO] = "Info",
      [vim.diagnostic.severity.HINT] = "Hint",
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})
