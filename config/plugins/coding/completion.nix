# Autocompletion (blink.cmp)
{ ... }: {
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
          "<C-n>" = [ "select_next" "fallback" ];
          "<C-p>" = [ "select_prev" "fallback" ];
          "<C-j>" = [ "select_next" "fallback" ];
          "<C-k>" = [ "select_prev" "fallback" ];
          "<Down>" = [ "select_next" "fallback" ];
          "<Up>" = [ "select_prev" "fallback" ];
          "<C-d>" = [ "scroll_documentation_down" "fallback" ];
          "<C-u>" = [ "scroll_documentation_up" "fallback" ];
          "<C-y>" = [ "select_and_accept" "fallback" ];
          "<C-e>" = [ "cancel" "fallback" ];
          "<C-Space>" = [ "show" "show_documentation" "hide_documentation" ];
          "<CR>" = [ "accept" "fallback" ];
          "<Tab>" = [ "snippet_forward" "select_next" "fallback" ];
          "<S-Tab>" = [ "snippet_backward" "select_prev" "fallback" ];
        };

        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";
        };

        completion = {
          accept = { auto_brackets = { enabled = true; }; };
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 150;
            window = { max_height = 15; max_width = 60; };
          };
          menu = {
            border = "rounded";
            draw = {
              treesitter = [ "lsp" ];
              columns = [
                { __unkeyed-1 = "kind_icon"; }
                { __unkeyed-1 = "label"; __unkeyed-2 = "label_description"; gap = 1; }
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
          ghost_text = { enabled = false; };
        };

        signature = {
          enabled = true;
          window = { border = "rounded"; };
        };

        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ];
        };

        fuzzy = {
          implementation = "prefer_rust_with_warning";
          sorts = [ "exact" "score" "sort_text" ];
        };
      };
    };
  };
}
