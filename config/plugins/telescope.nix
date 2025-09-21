{
  config.plugins = {
    telescope = {
      enable = true;

      extensions = {
        file-browser = {
          enable = true;
        };
        fzf-native = {
          enable = true;
        };
        ui-select = {
          enable = true;
        };
      };

      settings = {
        defaults = {
          prompt_prefix = "  ";
          selection_caret = " ";
          entry_prefix = "  ";
          initial_mode = "insert";
          selection_strategy = "reset";
          sorting_strategy = "ascending";
          layout_strategy = "horizontal";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };

          # File and grep settings
          file_sorter = {
            __raw = "require('telescope.sorters').get_fuzzy_file";
          };
          file_ignore_patterns = [
            "%.git/"
            "%.git\\"
            "node_modules/"
            "vendor/"
            "%.cache"
            "%.o"
            "%.a"
            "%.out"
            "%.class"
            "%.pdf"
            "%.mkv"
            "%.mp4"
            "%.zip"
          ];
          generic_sorter = {
            __raw = "require('telescope.sorters').get_generic_fuzzy_sorter";
          };

          # Path display
          path_display = [ "truncate" ];

          # Window appearance
          winblend = 0;
          border = true;
          borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
          color_devicons = true;
          use_less = true;
          set_env = {
            COLORTERM = "truecolor";
          };

          # Grep settings
          vimgrep_arguments = [
            "rg"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
            "--hidden"
            "--glob=!.git/"
          ];

          # Mappings
          mappings = {
            i = {
              "<C-n>" = "move_selection_next";
              "<C-p>" = "move_selection_previous";
              "<C-c>" = "close";
              "<Down>" = "move_selection_next";
              "<Up>" = "move_selection_previous";
              "<CR>" = "select_default";
              "<C-x>" = "select_horizontal";
              "<C-v>" = "select_vertical";
              "<C-t>" = "select_tab";
              "<C-u>" = "preview_scrolling_up";
              "<C-d>" = "preview_scrolling_down";
              "<PageUp>" = "results_scrolling_up";
              "<PageDown>" = "results_scrolling_down";
              "<Tab>" = "toggle_selection + move_selection_worse";
              "<S-Tab>" = "toggle_selection + move_selection_better";
              "<C-q>" = "send_to_qflist + open_qflist";
              "<M-q>" = "send_selected_to_qflist + open_qflist";
              "<C-l>" = "complete_tag";
              "<C-_>" = "which_key"; # keys from pressing <C-/>
            };
            n = {
              "q" = "close";
              "<esc>" = "close";
              "<CR>" = "select_default";
              "x" = "select_horizontal";
              "v" = "select_vertical";
              "t" = "select_tab";
              "<Up>" = "move_selection_previous";
              "<Down>" = "move_selection_next";
              "gg" = "move_to_top";
              "G" = "move_to_bottom";
              "<C-u>" = "preview_scrolling_up";
              "<C-d>" = "preview_scrolling_down";
              "<PageUp>" = "results_scrolling_up";
              "<PageDown>" = "results_scrolling_down";
              "?" = "which_key";
            };
          };
        };

        pickers = {
          find_files = {
            find_command = [ "rg" "--files" "--hidden" "--glob" "!**/.git/*" ];
          };
          live_grep = {
            additional_args = [ "--hidden" ];
          };
          grep_string = {
            additional_args = [ "--hidden" ];
          };
          buffers = {
            theme = "dropdown";
            previewer = false;
            initial_mode = "normal";
            mappings = {
              i = {
                "<C-d>" = "delete_buffer";
              };
              n = {
                "dd" = "delete_buffer";
              };
            };
          };
          colorscheme = {
            enable_preview = true;
          };
          lsp_references = {
            theme = "dropdown";
            initial_mode = "normal";
          };
          lsp_definitions = {
            theme = "dropdown";
            initial_mode = "normal";
          };
          lsp_declarations = {
            theme = "dropdown";
            initial_mode = "normal";
          };
          lsp_implementations = {
            theme = "dropdown";
            initial_mode = "normal";
          };
        };
      };

      # Extensions are loaded via extraConfigLua
    };

    # Web devicons for file icons
    web-devicons = {
      enable = true;
    };
  };

  # Additional telescope configuration
  config.extraConfigLua = ''
    -- Load telescope extensions
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('file_browser')
  '';
}
