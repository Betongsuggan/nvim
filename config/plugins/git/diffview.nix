# diffview.nvim: tab-based diffs against any ref, file/branch history and
# the 3-way merge tool for conflicts. Closing its tab returns to the previous
# layout. Loaded by its commands.
{ ... }:
{
  plugins.diffview = {
    enable = true;
    lazyLoad.settings.cmd = [
      "DiffviewOpen"
      "DiffviewFileHistory"
      "DiffviewClose"
    ];
    settings = {
      enhanced_diff_hl = true;
      use_icons = true;
      view = {
        default = {
          layout = "diff2_horizontal";
          winbar_info = false;
        };
        merge_tool = {
          layout = "diff3_horizontal";
          disable_diagnostics = true;
        };
        file_history = {
          layout = "diff2_horizontal";
        };
      };
      file_panel = {
        listing_style = "tree";
        tree_options = {
          flatten_dirs = true;
          folder_statuses = "only_folded";
        };
        win_config = {
          position = "left";
          width = 35;
        };
      };
      file_history_panel = {
        win_config = {
          position = "bottom";
          height = 16;
        };
      };
    };
  };
}
