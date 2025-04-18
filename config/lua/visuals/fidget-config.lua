require("fidget").setup({
  -- Options related to LSP progress subsystem
  progress = {
    poll_rate = 0, -- How and when to poll for progress messages
    suppress_on_insert = false, -- Suppress new messages while in insert mode
    ignore_done_already = false, -- Ignore new tasks that are already complete
    ignore_empty_message = false, -- Ignore new tasks that don't contain a message
    clear_on_detach = function(client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      return client and client.name or nil
    end,
    notification_group = function(msg)
      return msg.lsp_client.name
    end,
    ignore = { -- List of LSP servers to ignore
      ["null-ls"] = true, -- Ignore null-ls to avoid duplicate notifications
    },

    -- Options related to how LSP progress messages are displayed as notifications
    display = {
      render_limit = 16, -- How many LSP messages to show at once
      done_ttl = 3, -- How long a message should persist after completion
      done_icon = "✅", -- Icon shown when all LSP progress tasks are complete
      done_style = "Constant", -- Highlight group for completed LSP tasks
      progress_ttl = math.huge, -- How long a message should persist when in progress
      progress_icon = { pattern = "dots_pulse", period = 125 }, -- Icon shown when LSP progress tasks are in progress
      progress_style = "WarningMsg", -- Highlight group for in-progress LSP tasks
      group_style = "Title", -- Highlight group for group name (LSP server name)
      icon_style = "Question", -- Highlight group for group icons
      priority = 30, -- Ordering priority for LSP notification group
      skip_history = true, -- Whether progress notifications should be omitted from history
    },

    -- Options related to Neovim's built-in LSP client
    lsp = {
      progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
      log_handler = false, -- Log `$/progress` handler invocations (for debugging)
    },
  },

  -- Options related to notification subsystem
  notification = {
    poll_rate = 10, -- How frequently to update and render notifications
    filter = vim.log.levels.INFO, -- Minimum notifications level
    history_size = 128, -- Number of removed messages to retain in history
    override_vim_notify = false, -- Automatically override vim.notify() with Fidget

    -- Options related to how notifications are rendered as text
    view = {
      stack_upwards = true, -- Display notification items from bottom to top
      icon_separator = " ", -- Separator between group name and icon
      group_separator = "---", -- Separator between notification groups
      group_separator_hl = "Comment", -- Highlight group used for group separator
    },

    -- Options related to the notification window and buffer
    window = {
      normal_hl = "Normal", -- Base highlight group in the notification window (changed from Comment to Normal)
      winblend = 0, -- Background color opacity in the notification window (changed from 10 to 0)
      zindex = 45, -- Stacking priority of the notification window
      border = "rounded",
      max_width = 80, -- Maximum width of the notification window
      max_height = 0, -- Maximum height of the notification window
      x_padding = 1, -- Padding from right edge of window boundary
      y_padding = 0, -- Padding from bottom edge of window boundary
      align = "bottom", -- How to align the notification window
      relative = "editor", -- What the notification window position is relative to
    },
  },

  -- Options related to integrating with other plugins
  integration = {
    ["nvim-tree"] = {
      enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
    },
  },

  -- Options related to logging
  logger = {
    level = vim.log.levels.WARN, -- Minimum logging level
    max_size = 10000, -- Maximum log file size, in KB
    float_precision = 0.01, -- Limit the number of decimals displayed for floats
    path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
  },
})
