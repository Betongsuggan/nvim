{
  config.plugins.neo-tree = {
    enable = true;

    closeIfLastWindow = true;
    popupBorderStyle = "rounded";
    enableGitStatus = true;
    enableDiagnostics = true;
    enableModifiedMarkers = true;
    enableRefreshOnWrite = true;

    defaultComponentConfigs = {
      indent = {
        indentSize = 2;
        padding = 1;
        withMarkers = true;
        indentMarker = "│";
        lastIndentMarker = "└";
        highlight = "NeoTreeIndentMarker";
        withExpanders = null;
        expanderCollapsed = "";
        expanderExpanded = "";
        expanderHighlight = "NeoTreeExpander";
      };

      icon = {
        folderEmpty = "";
        folderEmptyOpen = "";
        default = "*";
        highlight = "NeoTreeFileIcon";
      };

      name = {
        trailingSlash = false;
        useGitStatusColors = true;
        highlight = "NeoTreeFileName";
      };

      gitStatus = {
        symbols = {
          added = "";
          modified = "";
          deleted = "";
          renamed = "";
          untracked = "";
          ignored = "";
          unstaged = "";
          staged = "";
          conflict = "󰦦";
        };
      };
    };

    window = {
      position = "float";
      width = 40;
      mappingOptions = {
        noremap = true;
        nowait = true;
      };

      mappings = {
        "<space>" = {
          command = "toggle_node";
          nowait = true;
        };
        "o" = {
          command = "open";
          nowait = true;
        };
        "<2-LeftMouse>" = "open";
        "<cr>" = "open";
        "<esc>" = "cancel";
        "P" = {
          command = "toggle_preview";
          config = {
            useFloatingWindows = true;
          };
        };
        "l" = "focus_preview";
        "S" = "open_split";
        "s" = "open_vsplit";
        "t" = "open_tabnew";
        "w" = "open_with_window_picker";
        "C" = "close_node";
        "z" = "close_all_nodes";
        "a" = {
          command = "add";
          config = {
            showPath = "none"; # "none", "relative", "absolute"
          };
        };
        "A" = "add_directory"; # also accepts the optional config.show_path option like "add".
        "d" = "delete";
        "r" = "rename";
        "y" = "copy_to_clipboard";
        "x" = "cut_to_clipboard";
        "p" = "paste_from_clipboard";
        "c" = {
          command = "copy"; # takes text input for destination, also accepts the optional config.show_path option like "add":
          config = {
            showPath = "none"; # "none", "relative", "absolute"
          };
        };
        "m" = {
          command = "move"; # takes text input for destination, also accepts the optional config.show_path option like "add".
          config = {
            showPath = "none"; # "none", "relative", "absolute"
          };
        };
        "q" = "close_window";
        "R" = "refresh";
        "?" = "show_help";
        "<" = "prev_source";
        ">" = "next_source";
        "i" = "show_file_details";
      };
    };

    #nesting = {
    #  enabled = false;
    #  openFoldersUntilSingleChild = false; # Don't auto-expand single child folders
    #};

    #filesystemComponents = {
    #  # This is to use the existing file icon color
    #  # If you want to customize the color, you can use the file_icon component
    #  hcFiletypeIcon = "highlight";
    #  hcGitStatus = true;
    #};

    filesystem = {
      filteredItems = {
        visible = false; # when true, they will just be displayed differently than normal items
        hideDotfiles = true;
        hideGitignored = true;
        hideHidden = true;
        hideByName = [
          "node_modules"
        ];
        hideByPattern = [
          # "*.meta"
          # "*/src/*/tsconfig.json",
        ];
        alwaysShow = [
          ".gitignored"
        ];
        neverShow = [
          ".DS_Store"
          "thumbs.db"
        ];
        neverShowByPattern = [
          # uses glob style patterns
          # ".null-ls_*",
        ];
      };

      followCurrentFile = {
        enabled = true;
        leaveDirsOpen = true;
      };

      groupEmptyDirs = false; # when true, empty folders will be grouped together
      hijackNetrwBehavior = "open_default";
      useLibuvFileWatcher = true;

      window = {
        mappings = {
          "o" = {
            command = "open";
            nowait = true;
          };
          "<bs>" = "navigate_up";
          "." = "set_root";
          "H" = "toggle_hidden";
          "/" = "fuzzy_finder";
          "D" = "fuzzy_finder_directory";
          "#" = "fuzzy_sorter";
          "f" = "filter_on_submit";
          "<c-x>" = "clear_filter";
          "[g" = "prev_git_modified";
          "]g" = "next_git_modified";
        };
      };
    };

    buffers = {
      followCurrentFile = {
        enabled = true;
        leaveDirsOpen = true;
      };
      groupEmptyDirs = true;
      window = {
        mappings = {
          "bd" = "buffer_delete";
          "<bs>" = "navigate_up";
          "." = "set_root";
        };
      };
    };

    gitStatus = {
      window = {
        mappings = {
          "A" = "git_add_all";
          "gu" = "git_unstage_file";
          "ga" = "git_add_file";
          "gr" = "git_revert_file";
          "gc" = "git_commit";
          "gp" = "git_push";
          "gg" = "git_commit_and_push";
        };
      };
    };
  };

  config.extraConfigLua = ''
    -- Custom neo-tree commands
    vim.api.nvim_create_user_command("ExploreToggle", "Neotree toggle", {})
    vim.api.nvim_create_user_command("ExploreFloat", "Neotree float", {})
    vim.api.nvim_create_user_command("ExploreLeft", "Neotree left", {})
    vim.api.nvim_create_user_command("ExploreRight", "Neotree right", {})
    vim.api.nvim_create_user_command("ExploreCurrent", "Neotree reveal", {})
    
    -- Auto-close neo-tree when it's the last window
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match("neo%-tree://") ~= nil then
            table.insert(invalid_win, w)
          end
        end
        if #invalid_win == #wins - 1 then
          -- Should quit, so we close all invalid windows.
          for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
        end
      end
    })
  '';
}
