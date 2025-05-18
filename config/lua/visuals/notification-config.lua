local notify = require("notify")

-- Configure notify with better defaults
notify.setup({
  -- Animation style
  stages = "fade_in_slide_out",

  -- Default timeout for notifications
  timeout = 5000,

  -- For stages that change opacity, this is treated as the highlight behind the window
  background_colour = "#282828", -- Match Gruvbox background color

  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },

  -- Render style
  render = "default",

  -- Max height of notification window
  max_height = nil,

  -- Minimum width for notification windows
  minimum_width = 50,

  -- Top down or bottom up growth direction
  top_down = true,
})

-- Store the original notify function
local original_notify = notify

-- Override vim's notification function with enhanced version
-- This avoids the "duplicated field" warning from LSP
notify = function(msg, level, opts)
  opts = opts or {}

  -- Convert level from string to number if needed
  if type(level) == "string" then
    level = vim.log.levels[level:upper()] or vim.log.levels.INFO
  end

  -- Format tables nicely
  if type(msg) == "table" then
    msg = vim.inspect(msg)
  end

  -- Add border to notifications
  opts.border = opts.border or "rounded"

  -- Add relative time to notification title
  if opts.title then
    opts.title = opts.title .. " • " .. os.date("%H:%M:%S")
  end

  return original_notify(msg, level, opts)
end

-- Set vim.notify only once
vim.notify = notify

-- Enhanced LSP message handler
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local client_name = client and client.name or "Unknown"
  local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
  local icon = ({
    ERROR = " ",
    WARN = " ",
    INFO = " ",
    DEBUG = " ",
  })[lvl] or ""

  notify(result.message, lvl, {
    title = icon .. " LSP | " .. client_name,
    timeout = lvl == "ERROR" and 0 or (lvl == "WARN" and 10000 or 5000),
    keep = function()
      return lvl == "ERROR" or lvl == "WARN"
    end,
    on_open = function(win)
      -- Add highlight to make important notifications stand out
      if lvl == "ERROR" or lvl == "WARN" then
        vim.wo[win].winblend = 0
      else
        vim.wo[win].winblend = 10
      end
    end,
  })
end

-- Add diagnostic count to statusline (if you're using lualine)
-- Set up autocommand to show diagnostics in a notification, but with safeguards
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function(args)
    -- Wrap in pcall to prevent errors from propagating
    local status, err = pcall(function()
      -- Get the buffer number
      local bufnr = args.buf

      -- Check if the buffer is valid before proceeding
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      -- Get diagnostics for the current buffer
      local diagnostics = vim.diagnostic.get(bufnr)

      -- Skip if no diagnostics
      if #diagnostics == 0 then
        return
      end

      -- Get the buffer name safely
      local filename
      local name_status, name = pcall(vim.api.nvim_buf_get_name, bufnr)
      if name_status and name and name ~= "" then
        filename = vim.fn.fnamemodify(name, ":t")
      else
        filename = "[No Name]"
      end

      -- Format the notification message
      --local message = string.format("Diagnostics for %s", filename)

      -- Use vim.schedule to defer the notification to the next event loop iteration
      -- This avoids the "not allowed to change text" error
      --vim.schedule(function()
      --  -- Only show notification if we're not in the process of exiting
      --  if vim.v.exiting == nil then
      --    notify(message, "info", {
      --      title = "Diagnostics Updated",
      --      timeout = 2000,
      --    })
      --  end
      --end)
    end)

    -- If there was an error, we just silently ignore it
    -- This prevents error messages from appearing during buffer cleanup
    if not status then
      -- Optionally log the error for debugging
      -- vim.api.nvim_echo({{err, "ErrorMsg"}}, false, {})
    end

  end,
})
vim.api.nvim_create_user_command("NotificationHistory", function()
  require("notify").history()
end, {})

-- Create command to dismiss all notifications
vim.api.nvim_create_user_command("NotificationDismiss", function()
  require("notify").dismiss()
end, {})

-- Create keymaps for notification navigation
vim.keymap.set("n", "<leader>fn", function()
  require("telescope").extensions.notify.notify()
end, { desc = "Find notifications" })
