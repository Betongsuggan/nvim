{ pkgs, ... }: {
  plugins.markdown-preview = {
    enable = true;
    settings = {
      auto_start = 0;
      auto_close = 1;
      theme = "dark";
    };
  };

  extraPlugins = [ pkgs.vimPlugins.render-markdown-nvim ];

  extraConfigLua = ''
    -- markdown-preview: Open in new Firefox window
    vim.cmd([[
      function! OpenMarkdownPreview(url)
        execute "silent !firefox --new-window " . a:url . " &"
      endfunction
      let g:mkdp_browserfunc = 'OpenMarkdownPreview'
    ]])

    -- render-markdown: In-editor visual rendering
    require('render-markdown').setup({
      enabled = true,
      render_modes = { 'n', 'c' },
      file_types = { 'markdown' },
      heading = {
        enabled = true,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      },
      code = {
        enabled = true,
        style = 'full',
        border = 'thin',
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰄵 ' },
      },
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>mp";
      action = "<cmd>MarkdownPreviewToggle<CR>";
      options = { desc = "Toggle markdown preview (browser)"; };
    }
    {
      mode = "n";
      key = "<leader>mr";
      action = { __raw = "function() require('render-markdown').toggle() end"; };
      options = { desc = "Toggle render-markdown (in-editor)"; };
    }
  ];
}
