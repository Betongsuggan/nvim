# Debugging: nvim-dap with dap-view (panels, inline values, controls).
# The languages with a debugger enable it (languages.nix).
{ config, icons, ... }:
{
  plugins.dap = {
    signs = {
      dapBreakpoint = {
        text = icons.dap.breakpoint;
        texthl = "DapBreakpoint";
      };
      dapBreakpointCondition = {
        text = icons.dap.condition;
        texthl = "DapBreakpoint";
      };
      dapBreakpointRejected = {
        text = icons.dap.rejected;
        texthl = "DapBreakpoint";
      };
      dapLogPoint = {
        text = icons.dap.log;
        texthl = "DapLogPoint";
      };
      dapStopped = {
        text = icons.dap.stopped;
        texthl = "DapStopped";
        linehl = "DapStoppedLine";
      };
    };
    # The paused line follows the colorscheme unless it styles it itself
    luaConfig.post = ''
      vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual", default = true })
    '';
  };

  # Panels for scopes, watches, breakpoints, threads and the REPL, opened
  # and closed with the debug session; variable values inline in the code
  plugins.dap-view = {
    inherit (config.plugins.dap) enable;
    settings = {
      auto_toggle = true;
      virtual_text.enabled = true;
      winbar = {
        default_section = "scopes";
        controls.enabled = true;
      };
    };
  };
}
