# Motions, project-wide search & replace, sessions.
{ ... }:
{
  plugins = {
    # Label jumps (s), treesitter selections (S in operator-pending/visual is
    # left to nvim-surround), remote operations
    flash = {
      enable = true;
      settings = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        modes = {
          char = {
            enabled = true;
            jump_labels = true;
          };
          search.enabled = false;
        };
      };
    };

    # Search & replace across the project with a live preview
    grug-far = {
      enable = true;
      lazyLoad.settings.cmd = "GrugFar";
    };

    # Per-directory sessions (buffers, layout, cursor), restored when nvim
    # starts without file arguments
    persistence.enable = true;
  };

  opts.sessionoptions = [
    "buffers"
    "curdir"
    "tabpages"
    "winsize"
    "help"
    "globals"
    "skiprtp"
  ];

  autoCmd = [
    {
      desc = "Restore the session of this directory";
      event = "VimEnter";
      nested = true;
      callback.__raw = ''
        function()
          if vim.fn.argc() == 0 and vim.fn.bufname() == "" then
            require("persistence").load()
          end
        end
      '';
    }
  ];
}
