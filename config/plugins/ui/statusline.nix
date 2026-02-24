# Lualine status bar configuration
{ theme }: {
  plugins.lualine = {
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
            modified = "*";
            readonly = "[RO]";
            unnamed = "[No Name]";
            newfile = "[New]";
          };
        }];
        lualine_c = [
          {
            __unkeyed-1 = "branch";
            icon = "";
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = "+ ";
              modified = "~ ";
              removed = "- ";
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
                      return "> " .. symbol
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
              error = "E ";
              warn = "W ";
              info = "I ";
              hint = "H ";
            };
          }
          {
            __unkeyed-1 = "encoding";
            fmt = { __raw = "string.upper"; };
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
}
