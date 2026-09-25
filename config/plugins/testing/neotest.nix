# Testing: neotest, loaded on first use (its keymaps require it). Test
# adapters come with each language.
{ pkgs, ... }:
let
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
  plugins.neotest = {
    enable = true;
    lazyLoad.settings.lazy = true;

    # neotest lists buffers and then reads each name in an async context;
    # pickers and claudecode diffs create scratch buffers that are gone by
    # then, which throws. Skip buffers that vanished (fails the build if the
    # upstream line changes).
    package = pkgs.vimPlugins.neotest.overrideAttrs {
      postPatch = ''
        substituteInPlace lua/neotest/client/init.lua --replace-fail \
          "    local name = nio.api.nvim_buf_get_name(bufnr)" \
          "    local ok, name = pcall(nio.api.nvim_buf_get_name, bufnr)
            if not ok then name = \"\" end"
      '';
    };

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
          # A jest.config.* when the project has one; otherwise jest reads
          # its config from package.json
          jestConfigFile.__raw = ''
            function()
              for _, name in ipairs({ "jest.config.ts", "jest.config.js", "jest.config.mjs" }) do
                local p = vim.fn.getcwd() .. "/" .. name
                if vim.fn.filereadable(p) == 1 then return p end
              end
            end
          '';
          env.CI = "true";
          cwd.__raw = "function() return vim.fn.getcwd() end";
        };
      };
      gradle.enable = true;
    };

    settings = {
      discovery.enabled = false;
      running.concurrent = false;
      output = {
        enabled = true;
        open_on_run = "short";
      };
      output_panel.open.__raw = "open_centered_float";
      floating = {
        max_height = 0.9;
        max_width = 0.9;
      };
      quickfix.enabled = false;
      status = {
        enabled = true;
        signs = true;
        virtual_text = false;
      };
      summary = {
        open.__raw = "open_centered_float";
        # Keys: keymaps.nix
      };
    };

    # Runs before neotest's setup (same chunk): the gradle adapter wrappers
    # and the open_centered_float the settings refer to
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
            spec.command = spec.command .. " --init-script " .. vim.fn.shellescape(init_script)
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
        })
      end
    '';
  };
}
