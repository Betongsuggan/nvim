{ ... }: {
  plugins = {
    # Test runner - language agnostic testing framework
    neotest = {
      enable = true;
      settings = {
        # Test discovery and execution settings
        discovery = {
          enabled = true;
          concurrent = 1;
        };
        # Test output settings
        output = {
          enabled = true;
          open_on_run = true;
        };
        # Test quickfix integration
        quickfix = {
          enabled = true;
          open = false;
        };
        # Test status configuration
        status = {
          enabled = true;
          signs = true;
          virtual_text = true;
        };
        # Floating window for test output
        output_panel = {
          enabled = true;
          open = "botright split | resize 15";
        };
        # Test running behavior
        run = {
          enabled = true;
        };
        # Test summary window
        summary = {
          enabled = true;
          animated = true;
          follow = true;
          expand_errors = true;
          mappings = {
            expand = [ "<CR>" "<2-LeftMouse>" ];
            expand_all = "e";
            output = "o";
            short = "O";
            attach = "a";
            jumpto = "i";
            stop = "u";
            run = "r";
            debug = "d";
            mark = "m";
            run_marked = "R";
            debug_marked = "D";
            clear_marked = "M";
            target = "t";
            clear_target = "T";
            next_failed = "J";
            prev_failed = "K";
            watch = "w";
          };
        };
        # Diagnostic integration
        diagnostic = {
          enabled = true;
          severity = 1;
        };
        # Floating test results
        floating = {
          border = "rounded";
          max_height = 0.9;
          max_width = 0.9;
          options = {};
        };
        # Test icons and signs
        icons = {
          child_indent = "│";
          child_prefix = "├";
          collapsed = "─";
          expanded = "╮";
          failed = "✖";
          final_child_indent = " ";
          final_child_prefix = "╰";
          non_collapsible = "─";
          passed = "✓";
          running = "●";
          running_animated = [ "/" "|" "\\" "-" "/" "|" "\\" "-" ];
          skipped = "○";
          unknown = "?";
        };
      };
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

  # Keymaps for testing and debugging
  keymaps = [
    # Test running
    {
      mode = "n";
      key = "<leader>tt";
      action = ":lua require('neotest').run.run()<CR>";
      options = {
        desc = "Run nearest test";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
      options = {
        desc = "Run tests in current file";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ta";
      action = ":lua require('neotest').run.run(vim.fn.getcwd())<CR>";
      options = {
        desc = "Run all tests";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = ":lua require('neotest').summary.toggle()<CR>";
      options = {
        desc = "Toggle test summary";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>to";
      action = ":lua require('neotest').output_panel.toggle()<CR>";
      options = {
        desc = "Toggle test output panel";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tw";
      action = ":lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>";
      options = {
        desc = "Watch tests in current file";
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
      key = "<leader>dB";
      action = ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
      options = {
        desc = "Set conditional breakpoint";
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
    {
      mode = "n";
      key = "<leader>ds";
      action = ":lua require('dap').step_over()<CR>";
      options = {
        desc = "Step over";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>di";
      action = ":lua require('dap').step_into()<CR>";
      options = {
        desc = "Step into";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>do";
      action = ":lua require('dap').step_out()<CR>";
      options = {
        desc = "Step out";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = ":lua require('dap').repl.toggle()<CR>";
      options = {
        desc = "Toggle debug REPL";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>du";
      action = ":lua require('dapui').toggle()<CR>";
      options = {
        desc = "Toggle debug UI";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action = ":lua require('neotest').run.run({strategy = 'dap'})<CR>";
      options = {
        desc = "Debug nearest test";
        silent = true;
      };
    }

  ];

  # Extra configuration for language-specific test adapters
  extraConfigLua = ''
    -- Configure neotest adapters for different languages
    require("neotest").setup({
      adapters = {
        -- Go testing
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" }
        }),
        
        -- Generic test detection
        require("neotest-plenary"),
      },
      
      -- Test discovery patterns
      discovery = {
        enabled = true,
        concurrent = 1,
      },
      
      -- Diagnostic integration  
      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },
      
      -- Floating windows
      floating = {
        border = "rounded",
        max_height = 0.9,
        max_width = 0.9,
        options = {}
      },
      
      -- Icons
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─", 
        expanded = "╮",
        failed = "✖",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "✓",
        running = "●",
        running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        skipped = "○",
        unknown = "?",
      },
      
      -- Output panel
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      
      -- Quickfix integration
      quickfix = {
        enabled = true,
        open = false,
      },
      
      -- Test running
      run = {
        enabled = true,
      },
      
      -- Status integration
      status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      },
      
      -- Test summary
      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
      },
    })
    
    -- Configure DAP UI to auto-open/close
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
    
    -- Configure Go debugging (since Go is in the dev environment)
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
      {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch", 
        mode = "test",
        program = ".''${relativeFileDirname}",
      },
    }
  '';
}