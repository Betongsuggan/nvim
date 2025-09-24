{
  config.plugins = {
    treesitter = {
      enable = true;

      settings = {
        ensureInstalled = [
          "go"
          "gomod"
          "gowork"
          "gosum"
          "lua"
          "vim"
          "vimdoc"
          "nix"
          "bash"
          "c"
          "markdown"
          "markdown_inline"
          "python"
          "javascript"
          "typescript"
          "html"
          "css"
          "json"
          "yaml"
          "toml"
          "regex"
          "dockerfile"
          "gitignore"
          "gitcommit"
          "diff"
          "sql"
        ];

        # Enable syntax highlighting
        highlight = {
          enable = true;
          additionalVimRegexHighlighting = false;
        };

        # Enable smart indentation
        indent = {
          enable = true;
        };

        # Enable incremental selection
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "<C-space>";
            nodeIncremental = "<C-space>";
            scopeIncremental = "<C-s>";
            nodeDecremental = "<M-space>";
          };
        };
      };

      # Automatically install missing parsers when entering buffer
      #autoInstall = true;

      # Install these parsers
      # Enable folding based on treesitter
      folding = true;
    };

    # Treesitter context - shows context of current function/class
    treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        maxLines = 0; # no limit
        minWindowHeight = 0; # no limit
        lineNumbers = true;
        multilineThreshold = 20;
        trimScope = "outer";
        mode = "cursor";
        separator = null;
        zindex = 20;
        onAttach = null;
      };
    };

    # Better text objects based on treesitter
    treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true; # Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          # You can use the capture groups defined in textobjects.scm
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "aa" = "@parameter.outer";
          "ia" = "@parameter.inner";
          "ab" = "@block.outer";
          "ib" = "@block.inner";
          "al" = "@loop.outer";
          "il" = "@loop.inner";
          "ai" = "@conditional.outer";
          "ii" = "@conditional.inner";
          "ak" = "@comment.outer";
        };
        selectionModes = {
          "@parameter.outer" = "v"; # charwise
          "@function.outer" = "V"; # linewise
          "@class.outer" = "<c-v>"; # blockwise
        };
        includeSurroundingWhitespace = true;
      };

      move = {
        enable = true;
        setJumps = true; # whether to set jumps in the jumplist
        gotoNextStart = {
          "]m" = "@function.outer";
          "]]" = "@class.outer";
          "]o" = "@loop.*";
          "]s" = { query = "@scope"; queryGroup = "locals"; desc = "Next scope"; };
          "]z" = { query = "@fold"; queryGroup = "folds"; desc = "Next fold"; };
        };
        gotoNextEnd = {
          "]M" = "@function.outer";
          "][" = "@class.outer";
        };
        gotoPreviousStart = {
          "[m" = "@function.outer";
          "[[" = "@class.outer";
          "[o" = "@loop.*";
          "[s" = { query = "@scope"; queryGroup = "locals"; desc = "Previous scope"; };
          "[z" = { query = "@fold"; queryGroup = "folds"; desc = "Previous fold"; };
        };
        gotoPreviousEnd = {
          "[M" = "@function.outer";
          "[]" = "@class.outer";
        };
      };

      swap = {
        enable = true;
        swapNext = {
          "<leader>a" = "@parameter.inner";
        };
        swapPrevious = {
          "<leader>A" = "@parameter.inner";
        };
      };
    };

    # Rainbow delimiters for better bracket visibility
    rainbow-delimiters = {
      enable = true;
      strategy = {
        "" = "global";
        vim = "local";
      };
      query = {
        "" = "rainbow-delimiters";
        lua = "rainbow-blocks";
      };
      #priority = {
      #  "" = 110;
      #  lua = 210;
      #};
      highlight = [
        "RainbowDelimiterRed"
        "RainbowDelimiterYellow"
        "RainbowDelimiterBlue"
        "RainbowDelimiterOrange"
        "RainbowDelimiterGreen"
        "RainbowDelimiterViolet"
        "RainbowDelimiterCyan"
      ];
    };

    # Auto-pairs for brackets, quotes, etc.
    nvim-autopairs = {
      enable = true;
      settings = {
        checkTs = true; # use treesitter to check for a pair
        tsConfig = {
          lua = [ "string" "source" ];
          javascript = [ "string" "template_string" ];
          java = false; # don't check treesitter on java
        };
        disableFiletypes = [ "TelescopePrompt" ];
        disableInMacro = true;
        disableInVisualblock = false;
        disableInReplace = false;
        ignoredNextChar = "[%w%.]"; # will ignore alphanumeric and `.` symbol
        enableMoveright = true;
        enableAfterquote = true; # add bracket pairs after quote
        enableCheckBracketLine = false; # check bracket in same line
        enableBracketInQuote = true;
        enableAbbr = false; # trigger abbreviation
        breakUndo = true; # switch for basic rule break undo sequence
        checkComma = true;
        mapChar = {
          all = "(";
          tex = "{";
        };
        mapCr = true;
        mapBs = true; # map the <BS> key
        mapCClearLine = true; # Map the <C-h> key to delete a pair
        mapCW = false; # map <c-w> to delete a pair if possible
      };
    };

    # Surround plugin for easy surround operations
    nvim-surround = {
      enable = true;
      settings = {
        keymaps = {
          insert = "<C-g>s";
          insertLine = "<C-g>S";
          normal = "ys";
          normalCur = "yss";
          normalLine = "yS";
          normalCurLine = "ySS";
          visual = "S";
          visualLine = "gS";
          delete = "ds";
          change = "cs";
          changeNext = "cns";
          changePrev = "cps";
        };
        aliases = {
          #["a"] = ">"; # >
          #["b"] = ")"; # )
          #["B"] = "}"; # }
          #["r"] = "]"; # ]
          #["q"] = { "\""; "'"; "`"; }; # Any quote
        };
        highlight = {
          duration = 0;
        };
        moveToEnd = false;
      };
    };
  };

  # Additional treesitter configuration
  config.extraConfigLua = ''
    -- All keymaps are centralized in keymaps.nix
    -- This file only contains treesitter configuration
    
    -- Custom treesitter commands for Go development
    vim.api.nvim_create_user_command('GoTestFunc', function()
      local ts_utils = require('nvim-treesitter.ts_utils')
      local current_node = ts_utils.get_node_at_cursor()
      
      -- Find the function node
      while current_node do
        if current_node:type() == 'function_declaration' then
          local func_name_node = current_node:field('name')[1]
          if func_name_node then
            local func_name = vim.treesitter.get_node_text(func_name_node, 0)
            if func_name:match('^Test') then
              vim.cmd('!go test -v -run ' .. func_name)
              return
            end
          end
        end
        current_node = current_node:parent()
      end
      
      print("No test function found at cursor")
    end, {})
    
    -- Highlight yanked text
    vim.api.nvim_create_autocmd('TextYankPost', {
      group = vim.api.nvim_create_augroup('highlight_yank', {}),
      pattern = '*',
      callback = function()
        vim.highlight.on_yank {
          higroup = 'IncSearch',
          timeout = 200,
        }
      end,
    })
    
    -- Go-specific treesitter configuration
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'go',
      callback = function()
        -- Set up Go-specific text objects
        vim.bo.commentstring = '// %s'
        -- All keymaps are in keymaps.nix
      end,
    })
    
    -- Better folding with treesitter
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldenable = false -- Don't fold by default
    
    -- Set up rainbow delimiter colors to match theme
    vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = '#E06C75' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = '#E5C07B' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#61AFEF' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = '#D19A66' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#98C379' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#C678DD' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = '#56B6C2' })
  '';
}
