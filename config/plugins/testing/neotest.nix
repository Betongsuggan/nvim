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

      -- One-shot init script: turn on FULL exception formatting so the
      -- captured Gradle stdout (what <leader>to opens) contains the actual
      -- assertion diff + stack trace, not just the exception type.
      local init_script = vim.fn.stdpath("cache") .. "/neotest-gradle-init.gradle"
      do
        local f = io.open(init_script, "w")
        if f then
          f:write([[
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
]])
          f:close()
        end
      end

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
        require("neotest-gradle"),
      },
      discovery = { enabled = false },
      running = { concurrent = false },
      output = { enabled = true, open_on_run = "short" },
      output_panel = { open = open_centered_float },
      floating = { max_height = 0.9, max_width = 0.9, border = "rounded" },
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
