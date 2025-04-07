vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]])
vim.fn.sign_define("LightBulbSign", { text = "💡", texthl = "LightBulbSignColor", linehl = "", numhl = "" })

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "🚨",
      [vim.diagnostic.severity.WARN] = "⚠️",
      [vim.diagnostic.severity.INFO] = "💬",
      [vim.diagnostic.severity.HINT] = "💡",
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    source = true,
    header = "",
    prefix = "",
  },
})
