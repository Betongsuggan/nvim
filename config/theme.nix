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
        backgroundColour = "#000000";
        fps = 30;
        render = "default";
        timeout = 500;
        topDown = true;
      };

      # Dashboard
      alpha = {
        enable = true;
        layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = [
              "██╗   ██╗██╗███╗   ███╗"
              "██║   ██║██║████╗ ████║"
              "██║   ██║██║██╔████╔██║"
              "╚██╗ ██╔╝██║██║╚██╔╝██║"
              " ╚████╔╝ ██║██║ ╚═╝ ██║"
              "  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            opts = {
              position = "center";
              hl = "Type";
            };
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = "  Find file";
                on_press = {
                  __raw = "function() require('telescope.builtin').find_files() end";
                };
                opts = {
                  keymap = [ "n" "ff" ":Telescope find_files <CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "ff";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = "  New file";
                on_press = {
                  __raw = "function() vim.cmd[[ene]] end";
                };
                opts = {
                  keymap = [ "n" "nf" ":ene <BAR> startinsert <CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "nf";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = "  Recently used files";
                on_press = {
                  __raw = "function() require('telescope.builtin').oldfiles() end";
                };
                opts = {
                  keymap = [ "n" "fr" ":Telescope oldfiles <CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "fr";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = "  Find text";
                on_press = {
                  __raw = "function() require('telescope.builtin').live_grep() end";
                };
                opts = {
                  keymap = [ "n" "fg" ":Telescope live_grep <CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "fg";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = "  Configuration";
                on_press = {
                  __raw = "function() vim.cmd[[e ~/.config/nvim/init.lua]] end";
                };
                opts = {
                  keymap = [ "n" "fc" ":e ~/.config/nvim/init.lua <CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "fc";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = "  Quit Neovim";
                on_press = {
                  __raw = "function() vim.cmd[[qa]] end";
                };
                opts = {
                  keymap = [ "n" "q" ":qa<CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "q";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
            ];
          }
          {
            type = "padding";
            val = 2;
          }
        ];
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
      
      -- Configure diagnostic signs with rounded appearance
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "󰌶" },
        { name = "DiagnosticSignInfo", text = "" },
      }
      
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end
      
      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = {
          active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    '';
  };
}
