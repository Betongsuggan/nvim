# Kotlin specifics that don't fit the language registry (languages.kotlin).
{
  config,
  lib,
  pkgs,
  ...
}:
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
lib.mkIf config.languages.kotlin.enable {
  # neotest-gradle fixes, run before neotest's setup
  plugins.neotest.luaConfig.pre = ''
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
  '';

  # The JetBrains kotlin-lsp returns goto-definition results for stdlib and
  # dependency symbols as `jar:///path/to/foo.jar!/inner/Path.kt` URIs, which
  # Neovim can't open (an empty buffer, and pickers crash positioning the
  # cursor). Read the entry out of the archive instead (needs unzip).
  autoCmd = [
    {
      desc = "Read source entries from inside JAR archives (kotlin-lsp goto-def)";
      event = "BufReadCmd";
      pattern = "jar://*";
      callback.__raw = ''
        function(args)
          local uri = args.match
          -- Strip "jar:" / "zipfile:" scheme and optional "file://" prefix,
          -- collapse leading slashes. Result: "<absolute-jar-path>!/<inner>".
          local rest = uri:gsub("^jar:", ""):gsub("^zipfile:", ""):gsub("^file://", "")
          rest = rest:gsub("^/+", "/")
          local jar, inner = rest:match("^(.-)!/(.+)$")
          if not jar or not inner then
            vim.notify("Could not parse jar URI: " .. uri, vim.log.levels.ERROR, { title = "jar" })
            return
          end

          local lines = vim.fn.systemlist({ "unzip", "-p", jar, inner })
          if vim.v.shell_error ~= 0 then
            vim.notify("unzip failed for " .. inner .. " in " .. jar, vim.log.levels.ERROR, { title = "jar" })
            return
          end

          vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
          vim.bo[args.buf].modifiable = false
          vim.bo[args.buf].readonly = true
          vim.bo[args.buf].buftype = "nofile"
          vim.bo[args.buf].swapfile = false
          local ft = vim.filetype.match({ filename = inner })
          if ft then
            vim.bo[args.buf].filetype = ft
          end
        end
      '';
    }
  ];
}
