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

  # Extra configuration for language-specific test adapters
  extraConfigLua = ''
    -- Configure neotest adapters for different languages
    local neotest_go_ok, neotest_go = pcall(require, "neotest-go")
    local neotest_plenary_ok, neotest_plenary = pcall(require, "neotest-plenary")
    
    local adapters = {}
    
    -- Add Go adapter if available
    if neotest_go_ok then
      -- Configure neotest-go with basic settings
      local go_adapter = neotest_go({
        experimental = {
          test_table = false, -- Disable table tests to avoid issues
        },
        args = { "-count=1", "-timeout=60s", "-race" }
      })
      table.insert(adapters, go_adapter)
      print("✓ neotest-go loaded successfully")
    else
      print("✗ Warning: neotest-go not available")
    end
    
    -- Add plenary adapter if available
    if neotest_plenary_ok then
      table.insert(adapters, neotest_plenary)
      print("✓ neotest-plenary loaded successfully")
    else
      print("✗ Warning: neotest-plenary not available")
    end
    
    -- Check if we have any adapters
    if #adapters == 0 then
      print("✗ No neotest adapters loaded! Tests will not work.")
      return
    end
    
    print("✓ Neotest configured with " .. #adapters .. " adapters")
    
    -- Safer neotest setup with error handling
    local neotest_ok, neotest_err = pcall(function()
      require("neotest").setup({
        adapters = adapters,
      
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
    end)
    
    -- Check if neotest setup succeeded
    if not neotest_ok then
      print("✗ Error setting up neotest: " .. (neotest_err or "unknown error"))
      return
    else
      print("✓ Neotest setup completed successfully")
    end
    
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