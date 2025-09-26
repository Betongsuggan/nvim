{ ... }: {
  plugins = {
    # Test runner - disable auto-setup, we'll do it manually
    neotest = {
      enable = true;
      # No auto adapters - we'll configure manually in extraConfigLua
      # to avoid compatibility issues
    };

    # Go debug adapter
    dap-go = { enable = true; };


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
    dap-ui = { enable = true; };

    # DAP Virtual Text
    dap-virtual-text = { enable = true; };
  };

  # Basic test keymaps
  keymaps = [
    # Universal test running - works with any supported language via adapters
    {
      mode = "n";
      key = "<leader>tt";
      action = {
        __raw = ''
          function() 
            local Runner = require('testing.runner')
            Runner.run_nearest_test()
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
            local Runner = require('testing.runner')
            Runner.run_file_tests()
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
            local Runner = require('testing.runner')
            Runner.run_all_tests()
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
      action = {
        __raw = ''
          function() 
            local Runner = require('testing.runner')
            Runner.debug_test_info()
          end
        '';
      };
      options = {
        desc = "Test info";
        silent = false;
      };
    }
    # New beautiful test UI keymaps
    {
      mode = "n";
      key = "<leader>to";
      action = {
        __raw = ''
          function() 
            local Runner = require('testing.runner')
            Runner.show_test_results()
          end
        '';
      };
      options = {
        desc = "Open test results in telescope";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = {
        __raw = ''
          function() 
            local Runner = require('testing.runner')
            Runner.show_raw_output()
          end
        '';
      };
      options = {
        desc = "Show raw test output";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = {
        __raw = ''
          function() 
            local Runner = require('testing.runner')
            Runner.clear_test_signs()
          end
        '';
      };
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

  # Initialize modular test runner system
  extraConfigLua = ''
    -- Initialize the modular test runner system
    local Runner = require('testing.runner')
    Runner.setup()

    -- Setup basic neotest without problematic Go adapter
    local ok, neotest = pcall(require, "neotest")
    if ok then
      pcall(function()
        neotest.setup({
          adapters = {
            -- Only use plenary adapter for Lua tests
            require("neotest-plenary"),
          },
          discovery = {
            enabled = false,
          },
          running = {
            concurrent = false,
          },
          output = {
            enabled = true,
            open_on_run = "short", 
          },
          quickfix = {
            enabled = false,
          },
          status = {
            enabled = true,
            signs = true,
            virtual_text = false,
          },
        })
      end)
    end
  '';
}

