# Trouble diagnostics configuration
{ ... }: {
  plugins.trouble = {
    enable = true;
    settings = {
      modes = {
        diagnostics = {
          mode = "diagnostics";
          preview = {
            type = "float";
            relative = "editor";
            border = "rounded";
            title = "Preview";
            title_pos = "center";
            position = [ 0 2 ];
            size = {
              width = 0.4;
              height = 0.4;
            };
            zindex = 200;
          };
        };
        buffer_diagnostics = {
          mode = "diagnostics";
          filter = { buf = 0; };
          preview = {
            type = "float";
            relative = "editor";
            border = "rounded";
            title = "Preview";
            title_pos = "center";
            position = [ 0 2 ];
            size = {
              width = 0.4;
              height = 0.4;
            };
            zindex = 200;
          };
        };
      };
      icons = {
        indent = {
          top = "| ";
          middle = "|-";
          last = "`-";
          fold_open = " ";
          fold_closed = " ";
          ws = "  ";
        };
        folder_closed = " ";
        folder_open = " ";
        kinds = {
          Array = " ";
          Boolean = " ";
          Class = " ";
          Constant = " ";
          Constructor = " ";
          Enum = " ";
          EnumMember = " ";
          Event = " ";
          Field = " ";
          File = " ";
          Function = " ";
          Interface = " ";
          Key = " ";
          Method = " ";
          Module = " ";
          Namespace = " ";
          Null = " ";
          Number = " ";
          Object = " ";
          Operator = " ";
          Package = " ";
          Property = " ";
          String = " ";
          Struct = " ";
          TypeParameter = " ";
          Variable = " ";
        };
      };
      win = {
        border = "rounded";
        type = "float";
        relative = "editor";
        position = "50%";
        size = {
          width = 0.8;
          height = 0.8;
        };
        zindex = 50;
      };
      preview = {
        type = "float";
        relative = "editor";
        border = "rounded";
        title = "Preview";
        title_pos = "center";
        position = [ 0 2 ];
        size = {
          width = 0.4;
          height = 0.4;
        };
        zindex = 100;
      };
      throttle = {
        refresh = 20;
        update = 10;
        render = 10;
        follow = 100;
        preview = {
          ms = 100;
          debounce = true;
        };
      };
      keys = {
        "?" = "help";
        r = "refresh";
        R = "toggle_refresh";
        q = "close";
        o = "jump_close";
        "<esc>" = "close";
        "<cr>" = "jump";
        "<2-leftmouse>" = "jump";
        "<c-s>" = "jump_split";
        "<c-v>" = "jump_vsplit";
        "}" = "next";
        "]]" = "next";
        "{" = "prev";
        "[[" = "prev";
        dd = "delete";
        d = { action = "delete"; mode = "v"; };
        i = "inspect";
        p = "preview";
        P = "toggle_preview";
        zo = "fold_open";
        zO = "fold_open_recursive";
        zc = "fold_close";
        zC = "fold_close_recursive";
        za = "fold_toggle";
        zA = "fold_toggle_recursive";
        zm = "fold_more";
        zM = "fold_close_all";
        zr = "fold_reduce";
        zR = "fold_open_all";
        zx = "fold_update";
        zX = "fold_update_all";
        zn = "fold_disable";
        zN = "fold_enable";
        zi = "fold_toggle_enable";
      };
    };
  };
}
