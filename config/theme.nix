{
  config = {
    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # latte, frappe, macchiato, mocha
        background = {
          light = "latte";
          dark = "mocha";
        };

        # Rounded corners theme preference
        transparent_background = false;
        show_end_of_buffer = false;
        term_colors = false;
        dim_inactive = {
          enabled = false;
          shade = "dark";
          percentage = 0.15;
        };

        # Plugin integrations with rounded corners where supported
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          neotree = true;
          treesitter = true;
          notify = false;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
          telescope = {
            enabled = true;
            style = "nvchad"; # Options: "borderless", "nvchad"
          };
          lsp_trouble = true;
          which_key = true;
        };

        # Custom highlights for rounded appearance
        custom_highlights = ''
          function(colors)
            return {
              -- Telescope with rounded borders
              TelescopeBorder = { fg = colors.blue },
              TelescopeSelectionCaret = { fg = colors.flamingo },
              TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
              TelescopeMatching = { fg = colors.blue },
              
              -- Completion menu
              Pmenu = { bg = colors.surface0, fg = colors.overlay2 },
              PmenuBorder = { bg = colors.surface0, fg = colors.surface1 },
              PmenuSel = { bg = colors.surface1, fg = colors.text, bold = true },
              
              -- LSP diagnostics with better visibility
              DiagnosticError = { fg = colors.red },
              DiagnosticWarn = { fg = colors.yellow },
              DiagnosticInfo = { fg = colors.sky },
              DiagnosticHint = { fg = colors.teal },
              
              -- Floating windows with rounded borders
              FloatBorder = { fg = colors.blue },
              NormalFloat = { bg = colors.base },
              
              -- Neo-tree
              NeoTreeNormal = { bg = colors.mantle },
              NeoTreeNormalNC = { bg = colors.mantle },
              
              -- Which-key
              WhichKey = { fg = colors.blue },
              WhichKeyGroup = { fg = colors.red },
              WhichKeyDesc = { fg = colors.text },
              WhichKeySeperator = { fg = colors.overlay0 },
              WhichKeyFloat = { bg = colors.mantle },
              WhichKeyBorder = { fg = colors.blue },
            }
          end
        '';
      };
    };

    # UI enhancements
    plugins = {
      # Statusline
      lualine = {
        enable = true;
        settings = {
          options = {
            iconsEnabled = true;
            theme = "catppuccin";

            componentSeparators = {
              left = "";
              right = "";
            };
            sectionSeparators = {
              left = "";
              right = "";
            };
          };

          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" "diff" "diagnostics" ];
            lualine_c = [ "filename" ];
            lualine_x = [ "encoding" "fileformat" "filetype" ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
          inactiveSections = {
            lualine_a = [ ];
            lualine_b = [ ];
            lualine_c = [ "filename" ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
        };
      };

      # Buffer line
      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            themable = true;
            numbers = "none";
            close_command = "bdelete! %d";
            right_mouse_command = "bdelete! %d";
            left_mouse_command = "buffer %d";
            middle_mouse_command = null;
            indicator = {
              icon = "▎";
              style = "icon";
            };
            buffer_close_icon = "󰅖";
            modified_icon = "●";
            close_icon = "";
            left_trunc_marker = "";
            right_trunc_marker = "";
            max_name_length = 30;
            max_prefix_length = 30;
            tab_size = 21;
            diagnostics = "nvim_lsp";
            diagnostics_update_in_insert = false;
            offsets = [
              {
                filetype = "neo-tree";
                text = "Neo-tree";
                text_align = "left";
                separator = true;
              }
            ];
            color_icons = true;
            show_buffer_icons = true;
            show_buffer_close_icons = true;
            show_close_icon = true;
            show_tab_indicators = true;
            persist_buffer_sort = true;
            separator_style = "slope"; # "slant", "slope", "thick", "thin"
            enforce_regular_tabs = false;
            always_show_bufferline = true;
            sort_by = "insert_after_current";
          };
          highlights = {
            separator = {
              fg = "#073642";
              bg = "#002b36";
            };
            separator_selected = {
              fg = "#073642";
            };
            background = {
              fg = "#657b83";
              bg = "#002b36";
            };
            buffer_selected = {
              fg = "#fdf6e3";
              bold = true;
            };
            fill = {
              bg = "#073642";
            };
          };
        };
      };

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
            tab_char = "│";
          };
          scope = {
            enabled = true;
            show_start = true;
            show_end = true;
            injected_languages = false;
            highlight = [ "Function" "Label" ];
            priority = 500;
          };
          exclude = {
            filetypes = [
              "help"
              "alpha"
              "dashboard"
              "neo-tree"
              "Trouble"
              "trouble"
              "lazy"
              "mason"
              "notify"
              "toggleterm"
              "lazyterm"
            ];
          };
        };
      };

      # Which-key for keybinding help
      which-key = {
        enable = true;
        settings = {
          delay = 200;
          expand = 1;
          notify = false;
          preset = false;
          replace = {
            desc = [
              [ "<space>" "SPC" ]
              [ "<leader>" "SPC" ]
              [ "<cr>" "RET" ]
              [ "<tab>" "TAB" ]
            ];
          };
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffers";
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "Terminal";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "Diagnostics";
            }
          ];
          win = {
            border = "rounded";
            padding = [ 1 2 ];
            wo = {
              winblend = 0;
            };
          };
          layout = {
            width = {
              min = 20;
            };
            spacing = 3;
          };
        };
      };

      # Notifications
      notify = {
        enable = true;
        settings = {
          backgroundColour = "#000000";
          fps = 30;
          render = "default";
          timeout = 500;
          topDown = true;
        };
      };
    };

    # Additional theming configuration
    extraConfigLua = ''
      -- Set rounded borders for floating windows
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end
    '';
  };
}
