# Mini.icons configuration with web-devicons compatibility
# Replaces web-devicons with the more modern mini.icons
{ pkgs, ... }: {
  # Disable web-devicons since we're using mini.icons
  plugins.web-devicons.enable = false;

  # Add mini.icons as extra plugin
  extraPlugins = [ pkgs.vimPlugins.mini-icons ];

  extraConfigLua = ''
    -- Setup mini.icons
    require('mini.icons').setup({
      -- Icon style: 'glyph' (default) or 'ascii'
      style = 'glyph',

      -- Customize default icons
      default = {
        file = { glyph = "", hl = 'MiniIconsGrey' },
        directory = { glyph = "", hl = 'MiniIconsAqua' },
      },

      -- Customize icons by extension
      extension = {
        nix = { glyph = "", hl = 'MiniIconsBlue' },
        go = { glyph = "", hl = 'MiniIconsCyan' },
        rs = { glyph = "", hl = 'MiniIconsOrange' },
        lua = { glyph = "", hl = 'MiniIconsBlue' },
        ts = { glyph = "", hl = 'MiniIconsBlue' },
        tsx = { glyph = "", hl = 'MiniIconsBlue' },
        js = { glyph = "", hl = 'MiniIconsYellow' },
        jsx = { glyph = "", hl = 'MiniIconsYellow' },
        py = { glyph = "", hl = 'MiniIconsYellow' },
        md = { glyph = "", hl = 'MiniIconsGrey' },
        json = { glyph = "", hl = 'MiniIconsYellow' },
        yaml = { glyph = "", hl = 'MiniIconsPurple' },
        yml = { glyph = "", hl = 'MiniIconsPurple' },
        toml = { glyph = "", hl = 'MiniIconsGrey' },
        sh = { glyph = "", hl = 'MiniIconsGreen' },
        bash = { glyph = "", hl = 'MiniIconsGreen' },
      },

      -- Customize icons by filename
      file = {
        ['.gitignore'] = { glyph = "", hl = 'MiniIconsGrey' },
        ['README.md'] = { glyph = "", hl = 'MiniIconsYellow' },
        ['Makefile'] = { glyph = "", hl = 'MiniIconsGrey' },
        ['Dockerfile'] = { glyph = "", hl = 'MiniIconsBlue' },
        ['Cargo.toml'] = { glyph = "", hl = 'MiniIconsOrange' },
        ['Cargo.lock'] = { glyph = "", hl = 'MiniIconsGrey' },
        ['go.mod'] = { glyph = "", hl = 'MiniIconsCyan' },
        ['go.sum'] = { glyph = "", hl = 'MiniIconsGrey' },
        ['package.json'] = { glyph = "", hl = 'MiniIconsGreen' },
        ['package-lock.json'] = { glyph = "", hl = 'MiniIconsGrey' },
        ['flake.nix'] = { glyph = "", hl = 'MiniIconsBlue' },
        ['flake.lock'] = { glyph = "", hl = 'MiniIconsGrey' },
      },

      -- Customize filetype icons
      filetype = {
        rust = { glyph = "", hl = 'MiniIconsOrange' },
        go = { glyph = "", hl = 'MiniIconsCyan' },
        typescript = { glyph = "", hl = 'MiniIconsBlue' },
        javascript = { glyph = "", hl = 'MiniIconsYellow' },
        lua = { glyph = "", hl = 'MiniIconsBlue' },
        nix = { glyph = "", hl = 'MiniIconsBlue' },
        python = { glyph = "", hl = 'MiniIconsYellow' },
      },

      -- LSP kind icons (for completion menu)
      lsp = {
        Class = { glyph = "", hl = 'MiniIconsOrange' },
        Color = { glyph = "", hl = 'MiniIconsRed' },
        Constant = { glyph = "", hl = 'MiniIconsOrange' },
        Constructor = { glyph = "", hl = 'MiniIconsBlue' },
        Enum = { glyph = "", hl = 'MiniIconsOrange' },
        EnumMember = { glyph = "", hl = 'MiniIconsYellow' },
        Event = { glyph = "", hl = 'MiniIconsOrange' },
        Field = { glyph = "", hl = 'MiniIconsGreen' },
        File = { glyph = "", hl = 'MiniIconsGrey' },
        Folder = { glyph = "", hl = 'MiniIconsBlue' },
        Function = { glyph = "", hl = 'MiniIconsBlue' },
        Interface = { glyph = "", hl = 'MiniIconsCyan' },
        Keyword = { glyph = "", hl = 'MiniIconsPurple' },
        Method = { glyph = "", hl = 'MiniIconsBlue' },
        Module = { glyph = "", hl = 'MiniIconsOrange' },
        Operator = { glyph = "", hl = 'MiniIconsGrey' },
        Property = { glyph = "", hl = 'MiniIconsGreen' },
        Reference = { glyph = "", hl = 'MiniIconsRed' },
        Snippet = { glyph = "", hl = 'MiniIconsYellow' },
        Struct = { glyph = "", hl = 'MiniIconsOrange' },
        Text = { glyph = "", hl = 'MiniIconsGrey' },
        TypeParameter = { glyph = "", hl = 'MiniIconsOrange' },
        Unit = { glyph = "", hl = 'MiniIconsOrange' },
        Value = { glyph = "", hl = 'MiniIconsOrange' },
        Variable = { glyph = "", hl = 'MiniIconsPurple' },
      },
    })

    -- Mock nvim-web-devicons for compatibility with plugins that expect it
    -- This must be called AFTER setup()
    MiniIcons.mock_nvim_web_devicons()
  '';
}
