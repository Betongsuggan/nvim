{ ... }: {
  plugins = {
    # Test runner - disable auto-setup, we'll do it manually
    neotest = {
      enable = true;
      # No auto adapters - we'll configure manually in extraConfigLua
      # to avoid compatibility issues
    };

    # Go debug adapter
    dap-go = {
      enable = true;
    };

    # Debug Adapter Protocol (DAP)
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

    # DAP UI
    dap-ui = {
      enable = true;
    };

    # DAP Virtual Text
    dap-virtual-text = {
      enable = true;
    };
  };

  # Basic test keymaps
  keymaps = [
    # Test running - smart detection between Go and other files
    {
      mode = "n";
      key = "<leader>tt";
      action = {
        __raw = ''
          function() 
            local file = vim.fn.expand('%:p')
            if file:match('%.go$') then
              run_go_test_nearest()
            else
              require('neotest').run.run()
            end
          end
        '';
      };
      options = {
        desc = "Run nearest test";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = {
        __raw = ''
          function() 
            local file = vim.fn.expand('%:p')
            if file:match('%.go$') then
              run_go_test_file()
            else
              require('neotest').run.run(vim.fn.expand('%'))
            end
          end
        '';
      };
      options = {
        desc = "Run tests in current file";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ta";
      action = {
        __raw = ''
          function() 
            local file = vim.fn.expand('%:p')
            if file:match('%.go$') then
              run_go_test_all()
            else
              require('neotest').run.run({suite = true})
            end
          end
        '';
      };
      options = {
        desc = "Run all tests";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ti";
      action = ":lua check_neotest()<CR>";
      options = {
        desc = "Test info";
        silent = false;
      };
    }
    # New beautiful test UI keymaps
    {
      mode = "n";
      key = "<leader>to";
      action = ":lua show_test_results_telescope()<CR>";
      options = {
        desc = "Open test results in telescope";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = ":lua show_raw_test_output()<CR>";
      options = {
        desc = "Show raw test output";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = ":lua clear_go_test_signs()<CR>";
      options = {
        desc = "Clear test signs from gutter";
        silent = true;
      };
    }
    
    # Debug keymaps
    {
      mode = "n";
      key = "<leader>db";
      action = ":lua require('dap').toggle_breakpoint()<CR>";
      options = {
        desc = "Toggle breakpoint";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = ":lua require('dap').continue()<CR>";
      options = {
        desc = "Continue debugging";
        silent = true;
      };
    }
  ];
}
