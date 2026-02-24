# Gitsigns configuration
{ ... }: {
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = { text = "+"; };
        change = { text = "~"; };
        delete = { text = "_"; };
        topdelete = { text = "-"; };
        changedelete = { text = "~"; };
        untracked = { text = "?"; };
      };
      signcolumn = true;
      numhl = false;
      linehl = false;
      word_diff = false;
      watch_gitdir = { follow_files = true; };
      attach_to_untracked = false;
      current_line_blame = false;
      sign_priority = 6;
      update_debounce = 300;
      status_formatter = null;
      max_file_length = 40000;
      preview_config = {
        border = "rounded";
        style = "minimal";
        relative = "cursor";
        row = 0;
        col = 1;
      };
    };
  };
}
