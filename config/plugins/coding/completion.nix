# Autocompletion (blink.cmp)
{ ... }: {
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        # Keys: keymaps.nix
        appearance = {
          nerd_font_variant = "mono";
        };

        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
            };
          };
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 150;
            window = {
              max_height = 15;
              max_width = 60;
            };
          };
          menu = {
            draw = {
              treesitter = [ "lsp" ];
              columns = [
                { __unkeyed-1 = "kind_icon"; }
                {
                  __unkeyed-1 = "label";
                  __unkeyed-2 = "label_description";
                  gap = 1;
                }
                { __unkeyed-1 = "source_name"; }
              ];
            };
          };
          list = {
            selection = {
              preselect = false;
              auto_insert = true;
            };
          };
          ghost_text = {
            enabled = false;
          };
        };

        signature = {
          enabled = true;
          window = {
          };
        };

        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };

        fuzzy = {
          implementation = "prefer_rust_with_warning";
          sorts = [
            "exact"
            "score"
            "sort_text"
          ];
        };
      };
    };
  };
}
