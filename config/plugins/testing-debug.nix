{ ... }: {
  plugins = {
    # Test runner - language agnostic testing framework
    neotest = {
      enable = true;
    };

    # Debug Adapter Protocol (DAP) for debugging
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "◯";
          texthl = "DapBreakpoint";
        };
        dapBreakpointRejected = {
          text = "✖";
          texthl = "DapBreakpoint";
        };
        dapLogPoint = {
          text = "◉";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "→";
          texthl = "DapStopped";
        };
      };
      
    };

    # DAP UI - visual debugging interface
    dap-ui = {
      enable = true;
    };

    # DAP Virtual Text - show variable values inline
    dap-virtual-text = {
      enable = true;
    };

  };

  # Keymaps for testing and debugging under <leader>c (code) prefix
  keymaps = [
    # FREQUENT: Single key commands for most common actions
    
    # Test running (most frequent)
    {
      mode = "n";
      key = "<leader>ct";
      action = ":lua require('neotest').run.run()<CR>";
      options = {
        desc = "Run test under cursor or nearest test";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
      options = {
        desc = "Run all tests in current file";
        silent = true;
      };
    }
    
    # Debug controls (frequent during debug session)
    {
      mode = "n";
      key = "<leader>cb";
      action = ":lua require('dap').toggle_breakpoint()<CR>";
      options = {
        desc = "Toggle breakpoint";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cc";
      action = ":lua require('dap').continue()<CR>";
      options = {
        desc = "Continue debugging";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = ":lua require('dap').step_over()<CR>";
      options = {
        desc = "Step over";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ci";
      action = ":lua require('dap').step_into()<CR>";
      options = {
        desc = "Step into";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>co";
      action = ":lua require('dap').step_out()<CR>";
      options = {
        desc = "Step out";
        silent = true;
      };
    }

    # LESS FREQUENT: Multi-key commands for setup/UI/advanced features

    # Test management (less frequent)
    {
      mode = "n";
      key = "<leader>cta";
      action = ":lua require('neotest').run.run(vim.fn.getcwd())<CR>";
      options = {
        desc = "Run all tests in project";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cti";
      action = ":lua local ok, neotest = pcall(require, 'neotest'); if ok then print('Adapters: ' .. #(neotest.config.adapters or {})); for i, adapter in ipairs(neotest.config.adapters or {}) do print('  ' .. i .. ': ' .. (adapter.name or 'unknown')); end else print('Neotest not loaded'); end; print('Go: ' .. (vim.fn.executable('go') == 1 and 'found' or 'missing')); print('Delve: ' .. (vim.fn.executable('dlv') == 1 and 'found' or 'missing'))<CR>";
      options = {
        desc = "Show test info (debug)";
        silent = false;
      };
    }
    {
      mode = "n";
      key = "<leader>cts";
      action = ":lua require('neotest').summary.toggle()<CR>";
      options = {
        desc = "Toggle test summary";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cto";
      action = ":lua require('neotest').output_panel.toggle()<CR>";
      options = {
        desc = "Toggle test output panel";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ctw";
      action = ":lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>";
      options = {
        desc = "Watch tests in current file";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ctd";
      action = ":lua require('neotest').run.run({strategy = 'dap'})<CR>";
      options = {
        desc = "Debug nearest test";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ctr";
      action = ":lua require('neotest').run.run_last()<CR>";
      options = {
        desc = "Re-run last test";
        silent = true;
      };
    }

    # Debug UI and advanced features (less frequent)
    {
      mode = "n";
      key = "<leader>cdb";
      action = ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
      options = {
        desc = "Set conditional breakpoint";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cdr";
      action = ":lua require('dap').repl.toggle()<CR>";
      options = {
        desc = "Toggle debug REPL";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cdu";
      action = ":lua require('dapui').toggle()<CR>";
      options = {
        desc = "Toggle debug UI";
        silent = true;
      };
    }

  ];

  # Essential configuration that must be in Lua
  extraConfigLua = ''
    -- Configure neotest adapters (required in Lua)
    require("neotest").setup({
      adapters = {
        require("neotest-go"),
        require("neotest-plenary"),
      }
    })
    
    -- Configure DAP for Go debugging  
    local dap = require("dap")
    
    dap.adapters.go = {
      type = "executable",
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:38697" },
    }
    
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "''${file}",
      },
      {
        type = "go",  
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "''${file}",
      },
    }
  '';
}