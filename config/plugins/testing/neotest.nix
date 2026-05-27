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
        dapStopped             = { text = ">"; texthl = "DapStopped";    };
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
    {
      mode = "n";
      key = "<leader>db";
      action = { __raw = "function() require('dap').toggle_breakpoint() end"; };
      options = { desc = "Toggle breakpoint"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = { __raw = "function() require('dap').continue() end"; };
      options = { desc = "Continue debugging"; silent = true; };
    }
  ];

  extraConfigLua = ''
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
        require("neotest-go"),
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
  '';
}
