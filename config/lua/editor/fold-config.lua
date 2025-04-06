local M = {}

function M.setup()
  -- Set folding method to use treesitter
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  -- Don't fold by default when opening a file
  vim.opt.foldenable = false

  -- Set fold level to avoid excessive folding
  vim.opt.foldlevel = 99

  -- Set fold text to make it more readable
  vim.opt.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]

  -- Add keymappings for folding
  local legendary = require("legendary")

  legendary.keymap({
    "<leader>zf",
    function()
      vim.cmd("normal! za")
    end,
    opts = { noremap = true, silent = true },
    description = "Toggle fold under cursor",
  })

  legendary.keymap({
    "<leader>zF",
    function()
      vim.cmd("normal! zA")
    end,
    opts = { noremap = true, silent = true },
    description = "Toggle all folds under cursor",
  })

  legendary.keymap({
    "<leader>zr",
    function()
      vim.cmd("set foldlevel+=1")
    end,
    opts = { noremap = true, silent = true },
    description = "Reduce folding (open one level)",
  })

  legendary.keymap({
    "<leader>zm",
    function()
      vim.cmd("set foldlevel-=1")
    end,
    opts = { noremap = true, silent = true },
    description = "More folding (close one level)",
  })

  legendary.keymap({
    "<leader>zR",
    function()
      vim.cmd("set foldlevel=99")
    end,
    opts = { noremap = true, silent = true },
    description = "Open all folds",
  })

  legendary.keymap({
    "<leader>zM",
    function()
      vim.cmd("set foldlevel=0")
    end,
    opts = { noremap = true, silent = true },
    description = "Close all folds",
  })
end

return M
