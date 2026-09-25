{ ... }:
let
  inherit (import ../../lib.nix) nmap luaFn;
in
{
  plugins.markdown-preview = {
    enable = true;
    settings = {
      auto_start = 0;
      auto_close = 1;
      theme = "dark";
    };
  };

  # render-markdown: In-editor visual rendering
  plugins.render-markdown = {
    enable = true;
    settings = {
      enabled = true;
      render_modes = [
        "n"
        "c"
      ];
      file_types = [ "markdown" ];
      heading = {
        enabled = true;
        icons = [
          "󰲡 "
          "󰲣 "
          "󰲥 "
          "󰲧 "
          "󰲩 "
          "󰲫 "
        ];
      };
      code = {
        enabled = true;
        style = "full";
        border = "thin";
      };
      checkbox = {
        enabled = true;
        unchecked = {
          icon = "󰄱 ";
        };
        checked = {
          icon = "󰄵 ";
        };
      };
    };
  };

  # Preview in the desktop's default browser
  plugins.markdown-preview.settings.browserfunc = "OpenMarkdownPreview";
  extraConfigVim = ''
    function! OpenMarkdownPreview(url)
      call jobstart(['xdg-open', a:url], {'detach': v:true})
    endfunction
  '';

  keymaps = [
    (nmap "<leader>mp" "<cmd>MarkdownPreviewToggle<CR>"
      "Toggle markdown preview (browser)"
    )
    (nmap "<leader>mr" (luaFn "require('render-markdown').toggle()")
      "Toggle render-markdown (in-editor)"
    )
  ];
}
