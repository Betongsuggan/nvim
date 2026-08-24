{ ... }:
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

  extraConfigLua = ''
    -- markdown-preview: Open in new Firefox window
    vim.cmd([[
      function! OpenMarkdownPreview(url)
        execute "silent !firefox --new-window " . a:url . " &"
      endfunction
      let g:mkdp_browserfunc = 'OpenMarkdownPreview'
    ]])
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>mp";
      action = "<cmd>MarkdownPreviewToggle<CR>";
      options = {
        desc = "Toggle markdown preview (browser)";
      };
    }
    {
      mode = "n";
      key = "<leader>mr";
      action = {
        __raw = "function() require('render-markdown').toggle() end";
      };
      options = {
        desc = "Toggle render-markdown (in-editor)";
      };
    }
  ];
}
