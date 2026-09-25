# Neotest + DAP. Replaces the prior custom test runner.
{ pkgs, ... }:
let
  inherit (import ../../lib.nix) nmapLua;
  gradleInitScript = pkgs.writeText "neotest-gradle-init.gradle" ''
    allprojects {
      tasks.withType(Test).configureEach {
        testLogging {
          events 'failed'
          showExceptions = true
          showCauses = true
          showStackTraces = true
          exceptionFormat = 'full'
        }
      }
    }
  '';
in
{
  plugins = {
    neotest = {
      enable = true;

      adapters = {
        golang = {
          enable = true;
          settings = {
            go_test_args = [
              "-v"
              "-count=1"
            ];
            dap_go_enabled = true;
          };
        };
        jest = {
          enable = true;
          settings = {
            jestCommand = "npx jest --";
            jestConfigFile.__raw = ''
              function()
                local cwd = vim.fn.getcwd()
                for _, name in ipairs({ "jest.config.ts", "jest.config.js" }) do
                  local p = cwd .. "/" .. name
                  if vim.fn.filereadable(p) == 1 then return p end
                end
                return cwd .. "/jest.config.js"
              end
            '';
            env = {
              CI = true;
            };
            cwd.__raw = "function() return vim.fn.getcwd() end";
          };
        };
        plenary.enable = true;
        gradle.enable = true;
      };

      settings = {
        discovery = {
          enabled = false;
        };
        running = {
          concurrent = false;
        };
        output = {
          enabled = true;
          open_on_run = "short";
        };
        output_panel = {
          open.__raw = "open_centered_float";
        };
        floating = {
          max_height = 0.9;
          max_width = 0.9;
          border = "rounded";
        };
        quickfix = {
          enabled = false;
        };
        status = {
          enabled = true;
          signs = true;
          virtual_text = false;
        };
        summary = {
          animated = true;
          open.__raw = "open_centered_float";
          mappings = {
            expand = [
              "<CR>"
              "<2-LeftMouse>"
            ];
            jumpto = "i";
            run = "r";
            debug = "d";
            stop = "u";
            watch = "w";
          };
        };
      };

      # Runs before nixvim's require("neotest").setup(...): the gradle and
      # client monkey-patches must be in place first, and the settings above
      # reference the open_centered_float local defined here (all plugin
      # setup code is emitted at the top level of the same chunk).
      luaConfig.pre = ''
        -- neotest-gradle queries Gradle's `testResultsDir` project property to
        -- locate JUnit XML reports, but Gradle 9 removed that convention property
        -- (it returns "null"). The plugin then concatenates "null/test" and the
        -- run crashes with ENOENT in collect_results. The actual reports still
        -- land at <projectDir>/build/test-results/test by convention, so we wrap
        -- build_spec and overwrite the cached path. Note the typo
        -- `test_resuls_directory` — matches the plugin's own field name.
        do
          local gradle_adapter = require("neotest-gradle")
          local find_project_directory = require("neotest-gradle.hooks.find_project_directory")
          local orig_build_spec = gradle_adapter.build_spec

          -- Init script turning on FULL exception formatting, so the captured
          -- Gradle stdout (what <leader>to opens) contains the actual assertion
          -- diff + stack trace, not just the exception type.
          local init_script = "${gradleInitScript}"

          gradle_adapter.build_spec = function(args)
            local spec = orig_build_spec(args)
            if spec then
              local project_dir = find_project_directory(args.tree:data().path)
              spec.context = spec.context or {}
              spec.context.test_resuls_directory = project_dir .. "/build/test-results/test"
              -- Trim Gradle overhead per-run: skip remote-repo checks and cache
              -- the configuration phase. Daemon is on by default.
              spec.command = spec.command
                .. " --offline --configuration-cache"
                .. " --init-script " .. vim.fn.shellescape(init_script)
            end
            return spec
          end

          -- Replace the full Gradle log with a focused per-test output file
          -- (just that test's JUnit XML failure block: assertion + stack
          -- trace). <leader>to becomes readable; the raw Gradle log is still
          -- available via the output_panel (<leader>tr).
          local function as_list(v)
            return (type(v) == "table" and #v > 0) and v or { v }
          end
          local orig_results = gradle_adapter.results
          gradle_adapter.results = function(spec, run_result, tree)
            local results = orig_results(spec, run_result, tree)
            local results_dir = spec.context and spec.context.test_resuls_directory
            if not results_dir or vim.fn.isdirectory(results_dir) == 0 then
              return results
            end
            local lib = require("neotest.lib")
            local xml = require("neotest.lib.xml")
            local xml_files = lib.files.find(results_dir, {
              filter_dir = function(name) return name:sub(-4) == ".xml" end,
            })
            for _, xml_path in ipairs(xml_files) do
              local ok_read, content = pcall(lib.files.read, xml_path)
              if ok_read then
                local ok_parse, parsed = pcall(xml.parse, content)
                if ok_parse and parsed then
                  for _, suite in ipairs(as_list(parsed.testsuite)) do
                    for _, case in ipairs(as_list(suite.testcase)) do
                      if case and case.failure then
                        local name = case._attr.name:gsub("%(.*%)$", "")
                        local cls = case._attr.classname
                        local candidates = {
                          cls .. "." .. name,
                          cls:gsub("%$", ".") .. "." .. name,
                        }
                        for _, id in ipairs(candidates) do
                          local r = results[id]
                          if r then
                            local trace = case.failure[1] or ""
                            local message = case.failure._attr.message or ""
                            local out = vim.fn.tempname()
                            local f = io.open(out, "w")
                            if f then
                              f:write(cls .. " > " .. name .. "\n")
                              f:write(string.rep("=", #cls + #name + 3) .. "\n\n")
                              if message ~= "" then f:write(message .. "\n\n") end
                              if trace ~= "" and trace ~= message then
                                f:write(trace .. "\n")
                              end
                              f:close()
                              r.output = out
                            end
                            break
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            return results
          end
        end

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
                    -- Must use nio.api (not vim.api) — this runs in a fast
                    -- coroutine context where vim.api.* calls assert. Picker /
                    -- claudecode diff plugins surface buffers that disappear
                    -- between list_bufs() and get_name(), hence the pcall.
                    local valid_ok, valid = pcall(nio.api.nvim_buf_is_valid, bufnr)
                    if valid_ok and valid then
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
      '';

      # Highlight the line where execution is paused. Linked to `Visual` so it
      # follows the colorscheme; `default = true` lets the active theme
      # override if it defines its own DapStoppedLine.
      luaConfig.post = ''
        vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual", default = true })
      '';
    };
    dap-go = {
      enable = true;
    };
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "*";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "o";
          texthl = "DapBreakpoint";
        };
        dapBreakpointRejected = {
          text = "x";
          texthl = "DapBreakpoint";
        };
        dapLogPoint = {
          text = "@";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = ">";
          texthl = "DapStopped";
          linehl = "DapStoppedLine";
        };
      };
    };
    dap-ui = {
      enable = true;
    };
    dap-virtual-text = {
      enable = true;
    };
  };

  keymaps = [
    (nmapLua "<leader>tt" "require('neotest').run.run()" "Run nearest test")
    (nmapLua "<leader>tf" "require('neotest').run.run(vim.fn.expand('%'))"
      "Run tests in current file"
    )
    (nmapLua "<leader>ta" "require('neotest').run.run(vim.fn.getcwd())"
      "Run all tests in cwd"
    )
    (nmapLua "<leader>tl" "require('neotest').run.run_last()" "Run last test")
    (nmapLua "<leader>ti" "require('neotest').summary.toggle()"
      "Test summary panel"
    )
    (nmapLua "<leader>to"
      "require('neotest').output.open({ enter = true, auto_close = true })"
      "Open test output (last)"
    )
    (nmapLua "<leader>tr" "require('neotest').output_panel.toggle()"
      "Toggle raw output panel"
    )
    (nmapLua "<leader>ts" "require('neotest').run.stop()" "Stop running test")
    (nmapLua "<leader>td" "require('neotest').run.run({ strategy = 'dap' })"
      "Debug nearest test (DAP)"
    )
    (nmapLua "<leader>tw" "require('neotest').watch.toggle(vim.fn.expand('%'))"
      "Watch tests in current file"
    )
    # --- Debug (<leader>d*) ----------------------------------------------
    # Breakpoints
    (nmapLua "<leader>db" "require('dap').toggle_breakpoint()" "Toggle breakpoint")
    {
      mode = "n";
      key = "<leader>dB";
      action = {
        __raw = ''
          function()
            vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
              if cond and cond ~= "" then require('dap').set_breakpoint(cond) end
            end)
          end
        '';
      };
      options = {
        desc = "Conditional breakpoint";
        silent = true;
      };
    }
    # Control flow
    (nmapLua "<leader>dc" "require('dap').continue()" "Continue")
    (nmapLua "<leader>dn" "require('dap').step_over()" "Step over")
    (nmapLua "<leader>di" "require('dap').step_into()" "Step into")
    (nmapLua "<leader>do" "require('dap').step_out()" "Step out")
    (nmapLua "<leader>dC" "require('dap').run_to_cursor()" "Run to cursor")
    (nmapLua "<leader>dq" "require('dap').terminate()" "Terminate session")
    # Inspection (on-demand centered floats)
    (nmapLua "<leader>dv"
      "require('dapui').float_element('scopes', { enter = true })"
      "Variables (scopes)"
    )
    (nmapLua "<leader>dw"
      "require('dapui').float_element('watches', { enter = true })"
      "Watches"
    )
    (nmapLua "<leader>ds"
      "require('dapui').float_element('stacks', { enter = true })"
      "Call stack"
    )
    (nmapLua "<leader>dl"
      "require('dapui').float_element('breakpoints', { enter = true })"
      "Breakpoints list"
    )
    (nmapLua "<leader>dr" "require('dapui').float_element('repl', { enter = true })"
      "REPL"
    )
    (nmapLua "<leader>dh" "require('dapui').eval(nil, { enter = true })"
      "Hover / inspect under cursor"
    )
    {
      mode = "n";
      key = "<leader>de";
      action = {
        __raw = ''
          function()
            vim.ui.input({ prompt = "Eval: " }, function(expr)
              if expr and expr ~= "" then
                require('dapui').eval(expr, { enter = true })
              end
            end)
          end
        '';
      };
      options = {
        desc = "Eval expression";
        silent = true;
      };
    }
  ];
}
