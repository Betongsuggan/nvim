# Lualine status bar configuration
{ icons, ... }:
{
  plugins.navic = {
    enable = true;
    settings = {
      lsp.auto_attach = true;
      highlight = true;
    };
  };

  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        # Derived from the active colorscheme's highlight groups
        theme = "auto";
        # Rounded caps on the outer sections only
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = icons.separators.right;
          right = icons.separators.left;
        };
        globalstatus = true;
        # lualine redraws on editor events; its queue is drained every
        # refresh_time ms, for as long as nvim runs (default 16 ms, ~60
        # wake-ups/s per instance even when idle). 100 ms still feels
        # instant. The periodic statusline redraw only catches state that
        # changes without an event, so it can be slow. No tabline/winbar.
        refresh = {
          refresh_time = 100;
          statusline = 5000;
          events = [
            "WinEnter"
            "BufEnter"
            "BufWritePost"
            "SessionLoadPost"
            "FileChangedShellPost"
            "VimResized"
            "Filetype"
            "CursorMoved"
            "CursorMovedI"
            "ModeChanged"
            "DiagnosticChanged"
            "LspProgress"
          ];
        };
      };
      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "mode";
            separator = {
              left = icons.separators.left;
            };
            right_padding = 2;
          }
        ];
        lualine_b = [
          {
            __unkeyed-1 = "filename";
            symbols = {
              modified = "*";
              readonly = "[RO]";
              unnamed = "[No Name]";
              newfile = "[New]";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "branch";
            icon = icons.git.branch;
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = "+ ";
              modified = "~ ";
              removed = "- ";
            };
          }
          # Symbol breadcrumb from the language server
          "navic"
        ];
        lualine_x = [
          {
            __unkeyed-1 = "diagnostics";
            # One source: lualine adds the sources up, and nvim_lsp's are
            # the same diagnostics again
            sources = [ "nvim_diagnostic" ];
            symbols = builtins.mapAttrs (_: glyph: "${glyph} ") icons.diagnostics;
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
              unix = "LF";
              dos = "CRLF";
              mac = "CR";
            };
          }
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [
          {
            __unkeyed-1 = "location";
            separator = {
              right = icons.separators.right;
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
}
