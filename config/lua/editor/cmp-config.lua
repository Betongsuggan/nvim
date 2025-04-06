-- Configuration for auto completion

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local keymaps = require("editor/keymappings")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noselect",
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-S-j>"] = cmp.mapping.scroll_docs(-4),
    ["<C-S-k>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- from language server
    { name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
    { name = "luasnip" }, -- luasnip snippets
    { name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
    { name = "path" }, -- file paths
  }, {
    { name = "buffer", keyword_length = 2 }, -- source current buffer
    { name = "vsnip", keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
    { name = "calc" }, -- source for math calculation
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, item)
      -- Kind icons using emojis

      local kind_icons = {
        Text = "📝",
        Method = "🔧",
        Function = "🔮",
        Constructor = "🏗️",
        Field = "🏷️",
        Variable = "🔄",
        Class = "🏛️",
        Interface = "🔌",
        Module = "📦",
        Property = "🔑",
        Unit = "📏",
        Value = "💎",
        Enum = "🔢",
        Keyword = "🔤",
        Snippet = "✂️",
        Color = "🎨",
        File = "📄",
        Reference = "📎",
        Folder = "📁",
        EnumMember = "🔣",
        Constant = "🔒",
        Struct = "🧱",
        Event = "⚡",
        Operator = "➗",
        TypeParameter = "🔠",
      }

      -- Source specific icons with emojis
      local source_icons = {
        nvim_lsp = "🔍 LSP",
        luasnip = "✂️ Snippet",
        vsnip = "✂️ VSnip",
        buffer = "📋 Buffer",
        path = "🔍 Path",
        nvim_lua = "🌙 Lua",
        calc = "🧮 Calc",
      }

      -- Set the kind icon
      item.kind = string.format("%s %s", kind_icons[item.kind] or "", item.kind)

      -- Set the source name in the menu
      item.menu = source_icons[entry.source.name] or entry.source.name

      return item
    end,
  },
  experimental = {
    ghost_text = true,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
