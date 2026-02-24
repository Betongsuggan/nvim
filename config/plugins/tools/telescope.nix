# Telescope fuzzy finder configuration
{ ... }: {
  plugins.telescope = {
    enable = true;
    extensions = { fzf-native = { enable = true; }; };
    settings = {
      defaults = {
        prompt_prefix = " ";
        selection_caret = "> ";
        entry_prefix = "  ";
        initial_mode = "insert";
        path_display = [ "truncate" ];
        sorting_strategy = "ascending";
        borderchars = [ "-" "|" "-" "|" "+" "+" "+" "+" ];
        dynamic_preview_title = true;
        layout_config = {
          horizontal = {
            prompt_position = "top";
            preview_width = 0.55;
            results_width = 0.8;
          };
          vertical = { mirror = false; };
          width = 0.87;
          height = 0.8;
          preview_cutoff = 120;
        };
      };
      pickers = {
        diagnostics = {
          theme = "dropdown";
          initial_mode = "normal";
          layout_config = { preview_cutoff = 9999; };
        };
        lsp_implementations = {
          theme = "dropdown";
          initial_mode = "normal";
          layout_config = {
            preview_cutoff = 50;
            preview_width = 0.5;
          };
          show_line = false;
          trim_text = true;
          include_declaration = false;
        };
        lsp_definitions = {
          theme = "dropdown";
          initial_mode = "normal";
          layout_config = {
            preview_cutoff = 50;
            preview_width = 0.5;
          };
          show_line = false;
          trim_text = true;
        };
        lsp_references = {
          theme = "dropdown";
          initial_mode = "normal";
          layout_config = { preview_cutoff = 50; };
          show_line = false;
          trim_text = true;
          include_declaration = false;
        };
      };
    };
  };
}
