# Custom floating side-by-side diff viewer.
#
# diffview.nvim is locked to a tabpage by design, so for the common
# "what did I change in this file vs HEAD/<ref>" case we run a smaller
# purpose-built viewer: two centered floats, both diff'd, with the left
# side showing the file at a chosen git revision and the right side
# showing the working tree. Closes via `q` or the global <Esc> float
# closer in keymaps.nix; the WinClosed autocmd cascades to take down
# the partner so we never leave an orphan float behind.
{ ... }: {
  keymaps = [
    {
      mode = "n";
      key = "<leader>gd";
      action = { __raw = "function() _G.git_floating_diff('HEAD') end"; };
      options = { desc = "Diff current file vs HEAD (float)"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = { __raw = "function() _G.git_floating_diff_prompt() end"; };
      options = { desc = "Diff current file vs <ref> (float)"; silent = true; };
    }
  ];

  extraConfigLua = ''
    local function notify(msg, level)
      vim.notify(msg, level or vim.log.levels.INFO, { title = "Git Diff" })
    end

    local function git_root()
      local out = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })
      if vim.v.shell_error ~= 0 or not out[1] then return nil end
      return out[1]
    end

    -- Open two centered floating windows side-by-side and `:diffthis`
    -- both. Left is `rev:path` (read-only scratch), right is a scratch
    -- copy of the current buffer so the user can't accidentally edit
    -- their working tree through the viewer.
    function _G.git_floating_diff(rev)
      rev = rev or "HEAD"

      local src_buf = vim.api.nvim_get_current_buf()
      local src_name = vim.api.nvim_buf_get_name(src_buf)
      if src_name == "" then
        notify("Current buffer has no file path", vim.log.levels.WARN)
        return
      end

      local root = git_root()
      if not root then
        notify("Not inside a git repository", vim.log.levels.WARN)
        return
      end

      local relpath = vim.fn.fnamemodify(src_name, ":.")
      -- `git show` wants a path relative to the repo root.
      local rel_to_root = vim.fn.fnamemodify(src_name, ":p"):sub(#root + 2)

      local show = vim.fn.systemlist({ "git", "-C", root, "show", rev .. ":" .. rel_to_root })
      if vim.v.shell_error ~= 0 then
        notify(("git show %s:%s failed"):format(rev, rel_to_root), vim.log.levels.ERROR)
        return
      end

      local ft = vim.bo[src_buf].filetype
      local working_lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)

      -- Geometry: 92% width / 88% height, centered, halved horizontally
      -- with a 2-col gutter between the two floats.
      local total_w = math.floor(vim.o.columns * 0.92)
      local total_h = math.floor(vim.o.lines * 0.88)
      local gutter = 2
      local pane_w = math.floor((total_w - gutter) / 2)
      local row = math.floor((vim.o.lines - total_h) / 2)
      local col_left = math.floor((vim.o.columns - total_w) / 2)
      local col_right = col_left + pane_w + gutter

      local function make_scratch(name, lines)
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].swapfile = false
        vim.bo[buf].modifiable = false
        if ft and ft ~= "" then vim.bo[buf].filetype = ft end
        pcall(vim.api.nvim_buf_set_name, buf, name)
        return buf
      end

      local left_buf = make_scratch(
        ("diff://%s:%s"):format(rev, relpath),
        show
      )
      local right_buf = make_scratch(
        ("diff://WORKING:%s"):format(relpath),
        working_lines
      )

      local function float_opts(col, title)
        return {
          relative = "editor",
          width = pane_w,
          height = total_h,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
          title = " " .. title .. " ",
          title_pos = "center",
        }
      end

      local left_win = vim.api.nvim_open_win(left_buf, false, float_opts(col_left, rev))
      local right_win = vim.api.nvim_open_win(right_buf, true, float_opts(col_right, "Working tree"))

      -- Apply per-window diff/visual options. `cursorbind`+`scrollbind`
      -- keep the two panes aligned so the side-by-side feels coherent.
      local function setup_window(win)
        vim.api.nvim_win_call(win, function()
          vim.cmd("diffthis")
          vim.wo.wrap = false
          vim.wo.number = true
          vim.wo.relativenumber = false
          vim.wo.cursorline = true
          vim.wo.scrollbind = true
          vim.wo.cursorbind = true
          vim.wo.foldcolumn = "0"
        end)
      end
      setup_window(left_win)
      setup_window(right_win)

      -- Closing one float should take down its partner. Guarded against
      -- recursion via the `closing` flag — closing window A fires
      -- WinClosed for A, which closes B, which fires WinClosed for B…
      local closing = false
      local function close_pair()
        if closing then return end
        closing = true
        pcall(vim.api.nvim_win_close, left_win, true)
        pcall(vim.api.nvim_win_close, right_win, true)
      end

      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = { tostring(left_win), tostring(right_win) },
        callback = close_pair,
      })

      -- `q` closes the viewer from either pane.
      for _, buf in ipairs({ left_buf, right_buf }) do
        vim.keymap.set("n", "q", close_pair, { buffer = buf, nowait = true, silent = true })
      end
    end

    -- Prompt for any git revision (commit hash, tag, branch, HEAD~3 …)
    -- and diff against it. Uses vim.ui.input which Snacks turns into a
    -- floating prompt, matching the rest of the UI.
    function _G.git_floating_diff_prompt()
      vim.ui.input({ prompt = "Diff against ref: ", default = "HEAD" }, function(rev)
        if rev and rev ~= "" then _G.git_floating_diff(rev) end
      end)
    end
  '';
}
