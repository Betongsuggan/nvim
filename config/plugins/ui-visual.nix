{ ... }: let
  theme = import ../theme.nix;
in {
  plugins = {
    # Icons (required by telescope and other plugins)
    web-devicons = {
      enable = true;
    };

    # Buffer tabline for open buffer visualization  
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
          diagnostics_indicator = {
            __raw = ''
              function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and "🚨 " or 
                           level:match("warning") and "⚠️ " or "💡 "
                return " " .. icon .. count
              end
            '';
          };
          color_icons = true;
          show_buffer_icons = true;
          show_buffer_close_icons = true;
          show_close_icon = true;
          show_tab_indicators = true;
          persist_buffer_sort = true;
          separator_style = "thick";
          enforce_regular_tabs = true;
          always_show_bufferline = true;
          sort_by = "insert_after_current";
        };
      };
    };

    # Which-Key for keymap discovery
    which-key = {
      enable = true;
      settings = {
        delay = 500;
        expand = 1;
        notify = false;
        preset = "modern";
        replace = {
          desc = [
            [ "<space>" " " ]
            [ "<leader>" " " ]
            [ "<[cC][rR]>" " " ]
            [ "<[tT][aA][bB]>" " " ]
            [ "<[bB][sS]>" " " ]
          ];
        };
        spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
            icon = "🔍";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
            icon = "💻";
          }
          {
            __unkeyed-1 = "<leader>p";
            group = "Project";
            icon = "📦";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffer";
            icon = "📄";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git";
            icon = "🌿";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "Windows";
            icon = "🪟";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "Theme";
            icon = "🎨";
          }
        ];
        win = {
          border = "rounded";
          padding = [ 1 2 ];
        };
      };
    };

    # Lualine status bar with emoji indicators
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = theme.name;
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
          globalstatus = true;
          refresh = {
            statusline = 1000;
            tabline = 1000;
            winbar = 1000;
          };
        };
        sections = {
          lualine_a = [
            {
              __unkeyed-1 = "mode";
              separator = {
                left = "";
              };
              right_padding = 2;
            }
          ];
          lualine_b = [
            {
              __unkeyed-1 = "filename";
              symbols = {
                modified = "●";
                readonly = "🔒";
                unnamed = "📝";
                newfile = "✨";
              };
            }
          ];
          lualine_c = [
            {
              __unkeyed-1 = "branch";
              icon = "🌿";
            }
            {
              __unkeyed-1 = "diff";
              symbols = {
                added = "✅ ";
                modified = "⚡ ";
                removed = "❌ ";
              };
            }
            {
              __unkeyed-1 = {
                __raw = ''
                  function()
                    local aerial_ok, aerial = pcall(require, "aerial")
                    if aerial_ok then
                      local symbol = aerial.get_location(true)
                      if symbol and symbol ~= "" then
                        return "📍 " .. symbol
                      end
                    end
                    return ""
                  end
                '';
              };
              cond = {
                __raw = ''
                  function()
                    local aerial_ok, aerial = pcall(require, "aerial")
                    return aerial_ok and aerial.get_location(true) ~= ""
                  end
                '';
              };
            }
          ];
          lualine_x = [
            {
              __unkeyed-1 = "diagnostics";
              sources = [ "nvim_diagnostic" "nvim_lsp" ];
              symbols = {
                error = "🚨 ";
                warn = "⚠️ ";
                info = "💡 ";
                hint = "💭 ";
              };
            }
            {
              __unkeyed-1 = "encoding";
              fmt = {
                __raw = "string.upper";
              };
            }
            {
              __unkeyed-1 = "fileformat";
              symbols = {
                unix = "🐧";
                dos = "🪟";
                mac = "🍎";
              };
            }
            "filetype"
          ];
          lualine_y = [
            "progress"
          ];
          lualine_z = [
            {
              __unkeyed-1 = "location";
              separator = {
                right = "";
              };
              left_padding = 2;
            }
          ];
        };
        inactive_sections = {
          lualine_a = [ "filename" ];
          lualine_b = [ ];
          lualine_c = [ ];
          lualine_x = [ ];
          lualine_y = [ ];
          lualine_z = [ "location" ];
        };
      };
    };

    # Git signs for signcolumn
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = "+";
          };
          change = {
            text = "~";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
          untracked = {
            text = "?";
          };
        };
        signcolumn = true;
        numhl = false;
        linehl = false;
        word_diff = false;
        watch_gitdir = {
          follow_files = true;
        };
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

    # Better diagnostics and quick fix navigation
    trouble = {
      enable = true;
      settings = {
        modes = {
          diagnostics = {
            mode = "diagnostics";
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [ 0 2 ];
              size = { width = 0.4; height = 0.4; };
              zindex = 200;
            };
          };
          buffer_diagnostics = {
            mode = "diagnostics";
            filter = {
              buf = 0;
            };
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [ 0 2 ];
              size = { width = 0.4; height = 0.4; };
              zindex = 200;
            };
          };
        };
        icons = {
          indent = {
            top = "│ ";
            middle = "├╴";
            last = "└╴";
            fold_open = " ";
            fold_closed = " ";
            ws = "  ";
          };
          folder_closed = " ";
          folder_open = " ";
          kinds = {
            Array = " ";
            Boolean = "󰨙 ";
            Class = " ";
            Constant = "󰏿 ";
            Constructor = " ";
            Enum = " ";
            EnumMember = " ";
            Event = " ";
            Field = " ";
            File = " ";
            Function = "󰊕 ";
            Interface = " ";
            Key = " ";
            Method = "󰊕 ";
            Module = " ";
            Namespace = "󰦮 ";
            Null = " ";
            Number = "󰎠 ";
            Object = " ";
            Operator = " ";
            Package = " ";
            Property = " ";
            String = " ";
            Struct = "󰆼 ";
            TypeParameter = " ";
            Variable = "󰀫 ";
          };
        };
        win = { 
          border = "rounded";
          type = "float";
          relative = "editor";
          position = "50%";
          size = { width = 0.8; height = 0.8; };
          zindex = 50;
        };
        preview = {
          type = "float";
          relative = "editor";
          border = "rounded";
          title = "Preview";
          title_pos = "center";
          position = [ 0 2 ];
          size = { width = 0.4; height = 0.4; };
          zindex = 100;
        };
        throttle = {
          refresh = 20;
          update = 10;
          render = 10;
          follow = 100;
          preview = { ms = 100; debounce = true; };
        };
        keys = {
          "?" = "help";
          r = "refresh";
          R = "toggle_refresh";
          q = "close";
          o = "jump_close";
          "<esc>" = "close";
          "<cr>" = "jump";
          "<2-leftmouse>" = "jump";
          "<c-s>" = "jump_split";
          "<c-v>" = "jump_vsplit";
          "}" = "next";
          "]]" = "next";
          "{" = "prev";
          "[[" = "prev";
          dd = "delete";
          d = { action = "delete"; mode = "v"; };
          i = "inspect";
          p = "preview";
          P = "toggle_preview";
          zo = "fold_open";
          zO = "fold_open_recursive";
          zc = "fold_close";
          zC = "fold_close_recursive";
          za = "fold_toggle";
          zA = "fold_toggle_recursive";
          zm = "fold_more";
          zM = "fold_close_all";
          zr = "fold_reduce";
          zR = "fold_open_all";
          zx = "fold_update";
          zX = "fold_update_all";
          zn = "fold_disable";
          zN = "fold_enable";
          zi = "fold_toggle_enable";
        };
      };
    };
  };
}