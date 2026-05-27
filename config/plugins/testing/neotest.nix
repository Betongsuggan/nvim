# Neotest + DAP. Replaces the prior custom test runner.
{ ... }: {
  plugins = {
    neotest = { enable = true; };
    dap-go = { enable = true; };
    dap = {
      enable = true;
      signs = {
        dapBreakpoint          = { text = "*"; texthl = "DapBreakpoint"; };
        dapBreakpointCondition = { text = "o"; texthl = "DapBreakpoint"; };
        dapBreakpointRejected  = { text = "x"; texthl = "DapBreakpoint"; };
        dapLogPoint            = { text = "@"; texthl = "DapLogPoint";   };
        dapStopped             = { text = ">"; texthl = "DapStopped"; linehl = "DapStoppedLine"; };
      };
    };
    dap-ui = { enable = true; };
    dap-virtual-text = { enable = true; };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = { __raw = "function() require('neotest').run.run() end"; };
      options = { desc = "Run nearest test"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = { __raw = "function() require('neotest').run.run(vim.fn.expand('%')) end"; };
      options = { desc = "Run tests in current file"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>ta";
      action = { __raw = "function() require('neotest').run.run(vim.fn.getcwd()) end"; };
      options = { desc = "Run all tests in cwd"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action = { __raw = "function() require('neotest').run.run_last() end"; };
      options = { desc = "Run last test"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>ti";
      action = { __raw = "function() require('neotest').summary.toggle() end"; };
      options = { desc = "Test summary panel"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>to";
      action = { __raw = "function() require('neotest').output.open({ enter = true, auto_close = true }) end"; };
      options = { desc = "Open test output (last)"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = { __raw = "function() require('neotest').output_panel.toggle() end"; };
      options = { desc = "Toggle raw output panel"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = { __raw = "function() require('neotest').run.stop() end"; };
      options = { desc = "Stop running test"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>td";
      action = { __raw = "function() require('neotest').run.run({ strategy = 'dap' }) end"; };
      options = { desc = "Debug nearest test (DAP)"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>tw";
      action = { __raw = "function() require('neotest').watch.toggle(vim.fn.expand('%')) end"; };
      options = { desc = "Watch tests in current file"; silent = true; };
    }
    # --- Debug (<leader>d*) ----------------------------------------------
    # Breakpoints
    {
      mode = "n";
      key = "<leader>db";
      action = { __raw = "function() require('dap').toggle_breakpoint() end"; };
      options = { desc = "Toggle breakpoint"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dB";
      action = { __raw = ''
        function()
          vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
            if cond and cond ~= "" then require('dap').set_breakpoint(cond) end
          end)
        end
      ''; };
      options = { desc = "Conditional breakpoint"; silent = true; };
    }
    # Control flow
    {
      mode = "n";
      key = "<leader>dc";
      action = { __raw = "function() require('dap').continue() end"; };
      options = { desc = "Continue"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dn";
      action = { __raw = "function() require('dap').step_over() end"; };
      options = { desc = "Step over"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>di";
      action = { __raw = "function() require('dap').step_into() end"; };
      options = { desc = "Step into"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>do";
      action = { __raw = "function() require('dap').step_out() end"; };
      options = { desc = "Step out"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dC";
      action = { __raw = "function() require('dap').run_to_cursor() end"; };
      options = { desc = "Run to cursor"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dq";
      action = { __raw = "function() require('dap').terminate() end"; };
      options = { desc = "Terminate session"; silent = true; };
    }
    # Inspection (on-demand centered floats)
    {
      mode = "n";
      key = "<leader>dv";
      action = { __raw = "function() require('dapui').float_element('scopes', { enter = true }) end"; };
      options = { desc = "Variables (scopes)"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dw";
      action = { __raw = "function() require('dapui').float_element('watches', { enter = true }) end"; };
      options = { desc = "Watches"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action = { __raw = "function() require('dapui').float_element('stacks', { enter = true }) end"; };
      options = { desc = "Call stack"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = { __raw = "function() require('dapui').float_element('breakpoints', { enter = true }) end"; };
      options = { desc = "Breakpoints list"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = { __raw = "function() require('dapui').float_element('repl', { enter = true }) end"; };
      options = { desc = "REPL"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dh";
      action = { __raw = "function() require('dapui').eval(nil, { enter = true }) end"; };
      options = { desc = "Hover / inspect under cursor"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>de";
      action = { __raw = ''
        function()
          vim.ui.input({ prompt = "Eval: " }, function(expr)
            if expr and expr ~= "" then
              require('dapui').eval(expr, { enter = true })
            end
          end)
        end
      ''; };
      options = { desc = "Eval expression"; silent = true; };
    }
  ];

  extraConfigLua = ''
    -- Workaround for a TOCTOU race in neotest's async buffer iteration that
    -- crashes when picker plugins (e.g. snacks.picker.undo) create ephemeral
    -- scratch buffers and destroy them between list_bufs() and buf_get_name().
    -- neotest.client returns a factory closure (the Client class is local),
    -- so we wrap the factory: on first instance, walk its metatable to reach
    -- the Client class and replace _update_open_buf_positions with a
    -- validity-checked variant.
    do
      local orig_factory = require("neotest.client")
      local patched = false
      package.loaded["neotest.client"] = function(adapter_group)
        local instance = orig_factory(adapter_group)
        if not patched then
          local mt = getmetatable(instance)
          local Client = mt and mt.__index
          if type(Client) == "table" then
            Client._update_open_buf_positions = function(self, adapter_id)
              local adapter = self._adapters[adapter_id]
              if not adapter then return end
              local nio = require("nio")
              for _, bufnr in ipairs(nio.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(bufnr) then
                  local ok, name = pcall(nio.api.nvim_buf_get_name, bufnr)
                  if ok and name and name ~= "" then
                    local file_path = require("neotest.lib").files.path.real(name) or name
                    if adapter.is_test_file(file_path) then
                      self:_update_positions(file_path, { adapter = adapter_id })
                    end
                  end
                end
              end
            end
            patched = true
          end
        end
        return instance
      end
    end

    -- Open a centered floating window for neotest panels (summary/output_panel).
    local function open_centered_float()
      local width  = math.floor(vim.o.columns * 0.85)
      local height = math.floor(vim.o.lines  * 0.85)
      vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        relative = "editor",
        width    = width,
        height   = height,
        row      = math.floor((vim.o.lines   - height) / 2),
        col      = math.floor((vim.o.columns - width)  / 2),
        style    = "minimal",
        border   = "rounded",
      })
    end

    require("neotest").setup({
      adapters = {
        require("neotest-golang")({
          go_test_args = { "-v", "-count=1" },
          dap_go_enabled = true,
        }),
        require("neotest-jest")({
          jestCommand = "npx jest --",
          jestConfigFile = function()
            local cwd = vim.fn.getcwd()
            for _, name in ipairs({ "jest.config.ts", "jest.config.js" }) do
              local p = cwd .. "/" .. name
              if vim.fn.filereadable(p) == 1 then return p end
            end
            return cwd .. "/jest.config.js"
          end,
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        }),
        require("neotest-plenary"),
      },
      discovery = { enabled = false },
      running = { concurrent = false },
      output = { enabled = true, open_on_run = "short" },
      output_panel = { open = open_centered_float },
      quickfix = { enabled = false },
      status = { enabled = true, signs = true, virtual_text = false },
      summary = {
        animated = true,
        open = open_centered_float,
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          jumpto = "i",
          run = "r",
          debug = "d",
          stop = "u",
          watch = "w",
        },
      },
    })

    -- Highlight the line where execution is paused. Linked to `Visual` so it
    -- follows the colorscheme; `default = true` lets the active theme
    -- override if it defines its own DapStoppedLine.
    vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual", default = true })
  '';
}
