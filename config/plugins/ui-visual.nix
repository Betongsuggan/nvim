{ ... }:
let theme = import ../theme.nix;
in {
  plugins = {
    # Icons (required by telescope and other plugins)
    web-devicons = { enable = true; };

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
          custom_filter = {
            __raw = ''
              function(buf_number, buf_numbers)
                -- Hide buffers with "claude" in their name
                local buf_name = vim.fn.bufname(buf_number)
                if buf_name:match("claude") then
                  return false
                end
                -- Hide terminal buffers
                if vim.api.nvim_buf_get_option(buf_number, 'buftype') == 'terminal' then
                  return false
                end
                return true
              end
            '';
          };
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
            group = "Testing";
            icon = "🧪";
          }
          {
            __unkeyed-1 = "<leader>T";
            group = "Theme";
            icon = "🎨";
          }
          {
            __unkeyed-1 = "<leader>l";
            group = "LSP";
            icon = "💡";
          }
          {
            __unkeyed-1 = "<leader>d";
            group = "Diagnostics";
            icon = "🩺";
          }
          {
            __unkeyed-1 = "<leader>/";
            group = "Comments";
            icon = "💬";
          }
          {
            __unkeyed-1 = "<C-a>";
            desc = "Toggle Claude";
            icon = "🤖";
          }
          {
            __unkeyed-1 = "<C-b>";
            desc = "Add current buffer to Claude";
            icon = "➕";
          }
          {
            __unkeyed-1 = "<C-s>";
            desc = "Send selection to Claude";
            icon = "📤";
            mode = "v";
          }
          {
            __unkeyed-1 = "<C-y>";
            desc = "Accept diff";
            icon = "✅";
          }
          {
            __unkeyed-1 = "<C-n>";
            desc = "Deny diff";
            icon = "❌";
          }
          {
            __unkeyed-1 = "<C-a>";
            desc = "Toggle Claude from terminal";
            icon = "🤖";
            mode = "t";
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
          lualine_a = [{
            __unkeyed-1 = "mode";
            separator = { left = ""; };
            right_padding = 2;
          }];
          lualine_b = [{
            __unkeyed-1 = "filename";
            symbols = {
              modified = "●";
              readonly = "🔒";
              unnamed = "📝";
              newfile = "✨";
            };
          }];
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
              fmt = { __raw = "string.upper"; };
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
          lualine_y = [ "progress" ];
          lualine_z = [{
            __unkeyed-1 = "location";
            separator = { right = ""; };
            left_padding = 2;
          }];
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
          add = { text = "+"; };
          change = { text = "~"; };
          delete = { text = "_"; };
          topdelete = { text = "‾"; };
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
              size = {
                width = 0.4;
                height = 0.4;
              };
              zindex = 200;
            };
          };
          buffer_diagnostics = {
            mode = "diagnostics";
            filter = { buf = 0; };
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [ 0 2 ];
              size = {
                width = 0.4;
                height = 0.4;
              };
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
          size = {
            width = 0.8;
            height = 0.8;
          };
          zindex = 50;
        };
        preview = {
          type = "float";
          relative = "editor";
          border = "rounded";
          title = "Preview";
          title_pos = "center";
          position = [ 0 2 ];
          size = {
            width = 0.4;
            height = 0.4;
          };
          zindex = 100;
        };
        throttle = {
          refresh = 20;
          update = 10;
          render = 10;
          follow = 100;
          preview = {
            ms = 100;
            debounce = true;
          };
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
          d = {
            action = "delete";
            mode = "v";
          };
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

    # Scrollbar with diagnostics and git integration  
    # Added as extraPlugin since it's not available as a built-in nixvim plugin
  };

  # UI-related configuration
  extraConfigLua = ''
    -- Configure nvim-scrollbar with color-coded line indicators
    require('scrollbar').setup({
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,
      max_lines = false,
      hide_if_all_visible = false,
      throttle_ms = 200,
      handle = {
        text = " ",
        blend = 30,
        color = "${theme.colors.border}",
        highlight = "CursorColumn",
        hide_if_all_visible = true,
      },
      marks = {
        Cursor = {
          text = "•",
          priority = 0,
          color = "${theme.colors.fg}",
          highlight = "Normal",
        },
        -- Search marks disabled since we don't use hlslens search handler
        Error = {
          text = { "─" },
          priority = 2,
          color = "${theme.colors.error}",
          highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
          text = { "─" },
          priority = 3,
          color = "${theme.colors.warn}",
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "─" },
          priority = 4,
          color = "${theme.colors.info}",
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "─" },
          priority = 5,
          color = "${theme.colors.hint}",
          highlight = "DiagnosticVirtualTextHint",
        },
        GitAdd = {
          text = "│",
          priority = 6,
          color = "${theme.colors.git_add}",
          highlight = "GitSignsAdd",
        },
        GitChange = {
          text = "│",
          priority = 7,
          color = "${theme.colors.git_change}",
          highlight = "GitSignsChange",
        },
        GitDelete = {
          text = "▁",
          priority = 8,
          color = "${theme.colors.git_delete}",
          highlight = "GitSignsDelete",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          "TextChanged",
          "VimResized",
          "WinScrolled",
        },
        clear = {
          "BufWinLeave",
          "TabLeave",
          "TermLeave",
          "WinLeave",
        },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = false,  -- Disable search handler to avoid hlslens dependency
      },
    })

    -- Integrate with gitsigns
    require('scrollbar.handlers.gitsigns').setup()

    -- Set up custom highlight groups based on theme
    vim.cmd([[
      highlight ScrollbarHandle guifg=${theme.colors.border}
      highlight ScrollbarErrorHandle guifg=${theme.colors.error}
      highlight ScrollbarWarnHandle guifg=${theme.colors.warn}
      highlight ScrollbarInfoHandle guifg=${theme.colors.info}
      highlight ScrollbarHintHandle guifg=${theme.colors.hint}
      highlight ScrollbarGitAddHandle guifg=${theme.colors.git_add}
      highlight ScrollbarGitChangeHandle guifg=${theme.colors.git_change}
      highlight ScrollbarGitDeleteHandle guifg=${theme.colors.git_delete}
    ]])

    -- Configure web-devicons with fallback icons for better compatibility
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if ok then
      devicons.setup({
        override = {
          default_icon = { icon = "📄", name = "Default" },
        },
        default = true,
        strict = true,
        override_by_filename = {
          [".gitignore"] = { icon = "🚫", name = "Gitignore" },
          ["README.md"] = { icon = "📖", name = "Readme" },
          ["Makefile"] = { icon = "🔨", name = "Makefile" },
          ["Dockerfile"] = { icon = "🐳", name = "Docker" },
        },
        override_by_extension = {
          ["nix"] = { icon = "❄️", name = "Nix" },
          ["go"] = { icon = "🐹", name = "Go" },
          ["js"] = { icon = "📜", name = "JavaScript" },
          ["ts"] = { icon = "📘", name = "TypeScript" },
          ["lua"] = { icon = "🌙", name = "Lua" },
          ["py"] = { icon = "🐍", name = "Python" },
          ["rs"] = { icon = "🦀", name = "Rust" },
          ["md"] = { icon = "📝", name = "Markdown" },
          ["json"] = { icon = "📋", name = "JSON" },
          ["yaml"] = { icon = "📋", name = "YAML" },
          ["yml"] = { icon = "📋", name = "YAML" },
          ["toml"] = { icon = "📋", name = "TOML" },
        },
      })
    end
  '';
}
