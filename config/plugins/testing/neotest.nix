# Testing: neotest, loaded on first use from its keymaps. The languages
# enable it along with their test adapter (languages.nix).
{ pkgs, ... }:
{
  plugins.neotest = {
    # Enabled by the languages with a test adapter (languages.nix)
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

    # Runs before neotest's setup (same chunk): the open_centered_float the
    # settings refer to
    luaConfig.pre = ''
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
