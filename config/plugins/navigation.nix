{ ... }: {
  plugins = {
    # File finder and navigation
    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          prompt_prefix = " ";
          selection_caret = "> ";
          entry_prefix = "  ";
          initial_mode = "insert";
          path_display = [ "truncate" ];
          sorting_strategy = "ascending";
          borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
          dynamic_preview_title = true;
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
        };
        pickers = {
          diagnostics = {
            theme = "dropdown";
            initial_mode = "normal";
            layout_config = {
              preview_cutoff = 9999;
            };
          };
        };
      };
    };

    # File explorer
    neo-tree = {
      enable = true;
      closeIfLastWindow = false;
      popupBorderStyle = "rounded";
      enableGitStatus = true;
      enableDiagnostics = true;
      
      
      window = {
        position = "float";
        width = 50;
        mappings = {
          "o" = "open";
          "<CR>" = "open";
          "l" = "open";
          "h" = "close_node";
          "z" = "close_all_nodes";
          "Z" = "expand_all_nodes";
          "<C-x>" = "open_split";
          "<C-v>" = "open_vsplit";
          "P" = "toggle_preview";
          "S" = "open_split";
          "s" = "open_vsplit";
        };
        mappingOptions = {
          noremap = true;
          nowait = true;
        };
      };
      filesystem = {
        followCurrentFile = {
          enabled = true;
          leaveDirsOpen = true;
        };
        hijackNetrwBehavior = "open_current";
        useLibuvFileWatcher = true;
        bindToCwd = false;
        cwdTarget = {
          sidebar = "tab";
          current = "window";
        };
        filteredItems = {
          visible = false;
          hideDotfiles = true;
          hideGitignored = true;
          hideHidden = true;
          hideByName = [
            ".DS_Store"
            "thumbs.db"
            "node_modules"
            "__pycache__"
          ];
          neverShow = [
            ".git"
          ];
        };
      };
    };

    # Symbol outline for code navigation
    aerial = {
      enable = true;
      settings = {
        backends = [ "lsp" "treesitter" "markdown" "asciidoc" "man" ];
        layout = {
          max_width = [ 40 0.2 ];
          width = null;
          min_width = 10;
          win_opts = {};
          default_direction = "prefer_right";
          placement = "window";
          preserve_equality = false;
        };
        attach_mode = "window";
        close_automatic_events = [ "unfocus" ];
        keymaps = {
          "?" = "actions.show_help";
          "g?" = "actions.show_help";
          "<CR>" = "actions.jump";
          "<2-LeftMouse>" = "actions.jump";
          "<C-v>" = "actions.jump_vsplit";
          "<C-s>" = "actions.jump_split";
          "p" = "actions.scroll";
          "<C-j>" = "actions.down_and_scroll";
          "<C-k>" = "actions.up_and_scroll";
          "{" = "actions.prev";
          "}" = "actions.next";
          "[[" = "actions.prev_up";
          "]]" = "actions.next_up";
          "q" = "actions.close";
          "o" = "actions.tree_toggle";
          "za" = "actions.tree_toggle";
          "O" = "actions.tree_toggle_recursive";
          "zA" = "actions.tree_toggle_recursive";
          "l" = "actions.tree_open";
          "zo" = "actions.tree_open";
          "L" = "actions.tree_open_recursive";
          "zO" = "actions.tree_open_recursive";
          "h" = "actions.tree_close";
          "zc" = "actions.tree_close";
          "H" = "actions.tree_close_recursive";
          "zC" = "actions.tree_close_recursive";
          "zr" = "actions.tree_increase_fold_level";
          "zR" = "actions.tree_open_all";
          "zm" = "actions.tree_decrease_fold_level";
          "zM" = "actions.tree_close_all";
          "zx" = "actions.tree_sync_folds";
          "zX" = "actions.tree_sync_folds";
        };
        lazy_load = true;
        disable_max_lines = 10000;
        disable_max_size = 2000000;
        filter_kind = [
          "Class"
          "Constructor" 
          "Enum"
          "Function"
          "Interface" 
          "Module"
          "Method"
          "Struct"
        ];
        highlight_mode = "split_width";
        highlight_closest = true;
        highlight_on_hover = false;
        highlight_on_jump = 300;
        autojump = false;
        icons = {};
        ignore = {
          unlisted_buffers = false;
          diff_windows = true;
          filetypes = [];
          buftypes = "special";
          wintypes = "special";
        };
        manage_folds = false;
        link_folds_to_tree = false;
        link_tree_to_folds = true;
        nerd_font = "auto";
        on_attach = {
          __raw = ''
            function(bufnr)
              -- Note: Removed { and } keymaps to preserve default paragraph navigation
              -- Use [[ and ]] for aerial navigation instead
            end
          '';
        };
        open_automatic = false;
        post_jump_cmd = "normal! zz";
        close_on_select = false;
        update_events = "TextChanged,InsertLeave";
        show_guides = false;
        float = {
          border = "rounded";
          relative = "cursor";
          max_height = 0.9;
          height = null;
          min_height = [ 8 0.1 ];
          override = {
            __raw = ''
              function(conf, source_winid)
                conf.anchor = "NE"
                conf.col = conf.col + 1
                conf.row = conf.row + 1
                return conf
              end
            '';
          };
        };
        lsp = {
          diagnostics_trigger_update = true;
          update_when_errors = true;
          update_delay = 300;
          priority = {
            __raw = ''
              {
                -- You can set a priority for certain symbols
                Class = 10,
                Constructor = 10,
                Enum = 10,
                Function = 10,
                Interface = 10,
                Module = 10,
                Method = 10,
                Struct = 10,
              }
            '';
          };
        };
        treesitter = {
          update_delay = 300;
        };
        markdown = {
          update_delay = 300;
        };
      };
    };
  };

  # Configure Neo-tree icons without overriding main configuration
  extraConfigLua = ''
    -- Configure Neo-tree icons after it's loaded
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeoTreeLoaded",
      once = true,
      callback = function()
        -- Update neo-tree icons
        local neotree = require("neo-tree")
        local current_config = neotree.get_state()
        
        -- Apply custom icons through renderer configuration
        pcall(function()
          require("neo-tree.ui.renderer").config.default_component_configs = vim.tbl_deep_extend("force", 
            require("neo-tree.ui.renderer").config.default_component_configs or {}, 
            {
              icon = {
                folder_closed = "📁",
                folder_open = "📂", 
                folder_empty = "📂",
                default = "*",
              },
              git_status = {
                symbols = {
                  added = "✚",
                  modified = "○",
                  deleted = "✖",
                  renamed = "➜", 
                  untracked = "★",
                  ignored = "◌",
                  unstaged = "✗",
                  staged = "✓",
                  conflict = "",
                }
              },
            }
          )
        end)
      end
    })
  '';
}