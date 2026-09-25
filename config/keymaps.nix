# Every keymap, in one place. Entries are data:
#   { key; action; desc; mode ? "n"; }
# `action` is an Ex command (cmd "…"), a Lua function body (lua "…") or keys.
# Global maps become nixvim `keymaps`; buffer-local ones (filetypes, files)
# are set by autocommands; which-key groups are declared here too, and a
# build-time check rejects the same key twice in one scope.
#
# Mnemonics (<leader> = space):
#   f find   l lsp   c code   x lists   g git   t test   d debug   a ai
#   b buffer   w window   q session/quit   m markdown   r rust   C crates
# Not listed here, but plugin defaults: nvim-surround (ys, cs, ds, visual S),
# gc comments (built in), dap-view's panel keys (shown in its winbar).
{
  config,
  lib,
  utils,
  ...
}:
let
  inherit (utils) cmd lua;
  inherit (lib.nixvim) toLuaObject;

  k = key: action: desc: { inherit key action desc; };
  inModes = mode: entry: entry // { inherit mode; };
  # Maps that only exist when `cond` holds (e.g. their plugin is enabled)
  onlyIf = cond: map (e: e // { when = cond; });

  jump =
    count: severity:
    lua "vim.diagnostic.jump({ count = ${toString count}${
      lib.optionalString (
        severity != null
      ) ", severity = vim.diagnostic.severity.${severity}"
    }, float = true })";
  prompt =
    label: default: body:
    lua ''
      vim.ui.input({ prompt = "${label}: ", default = "${default}" }, function(input)
        if input and input ~= "" then ${body} end
      end)
    '';

  # neotest's test adapters depend on it, so a copy is on the runtimepath
  # before lz-n loads it; trigger lz-n first so its setup runs
  neotest = "require('lz.n').trigger_load('neotest'); require('neotest')";

  groups = {
    "<leader>f" = "Find";
    "<leader>l" = "LSP";
    "<leader>c" = "Code";
    "<leader>x" = "Lists";
    "<leader>g" = "Git";
    "<leader>a" = "AI (Claude)";
    "<leader>b" = "Buffer";
    "<leader>w" = "Window";
    "<leader>q" = "Session";
    "<leader>m" = "Markdown";
  };

  global = [
    # Editor
    (k "<Esc>" (lua ''
      -- Close focusable floats (hover, signature, diagnostics, git previews);
      -- pickers and terminals map <Esc> themselves
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local ok, c = pcall(vim.api.nvim_win_get_config, win)
        if ok and c.relative ~= "" and c.focusable ~= false then
          pcall(vim.api.nvim_win_close, win, false)
        end
      end
      vim.cmd.nohlsearch()
    '') "Close floats, clear search highlight")
    (k "<leader>qq" (cmd "quit") "Quit")
    (k "<leader>qs" (lua "require('persistence').load()")
      "Restore session of this directory"
    )
    (k "<leader>ql" (lua "require('persistence').load({ last = true })")
      "Restore last session"
    )
    (k "<leader>qd" (lua "require('persistence').stop()") "Don't save this session")

    # Terminal and window movement (also from inside terminals)
    (inModes [ "n" "t" ] (
      k "<C-t>" (lua "Snacks.terminal.toggle()") "Toggle floating terminal"
    ))
    (inModes [ "n" "t" ] (k "<C-h>" "<C-w>h" "Window left"))
    (inModes [ "n" "t" ] (k "<C-j>" "<C-w>j" "Window below"))
    (inModes [ "n" "t" ] (k "<C-k>" "<C-w>k" "Window above"))
    (inModes [ "n" "t" ] (k "<C-l>" "<C-w>l" "Window right"))

    # Buffers
    (k "<leader>bs" (cmd "write") "Save")
    (k "<leader>bd" (lua "Snacks.bufdelete()") "Delete (keep layout)")
    (k "<leader>bD" (lua "Snacks.bufdelete({ force = true })")
      "Delete, discarding changes"
    )
    (k "<leader>bo" (lua "Snacks.bufdelete.other()") "Delete all others")
    (k "<leader>br" (cmd "checktime") "Reload if changed on disk")
    (k "<leader>bR" (cmd "edit!") "Reload from disk, discarding changes")
    (k "<leader>bW" (cmd "write!") "Overwrite disk with buffer")
    (k "<leader>bf" (cmd "diffsplit %") "Diff against the file on disk")
    (k "[b" (cmd "bprevious") "Previous buffer")
    (k "]b" (cmd "bnext") "Next buffer")

    # Windows
    (k "<leader>wv" (cmd "vsplit") "Split right")
    (k "<leader>ws" (cmd "split") "Split below")
    (k "<leader>wc" (cmd "close") "Close")
    (k "<leader>wo" (cmd "only") "Close all others")
    (k "<leader>ww" "<C-w>w" "Next window")
    (k "<leader>wr" "<C-w>r" "Rotate")
    (k "<leader>w=" "<C-w>=" "Equalize sizes")
    (k "<leader>w+" (cmd "resize +5") "Taller")
    (k "<leader>w-" (cmd "resize -5") "Shorter")
    (k "<leader>w>" (cmd "vertical resize +5") "Wider")
    (k "<leader>w<" (cmd "vertical resize -5") "Narrower")

    # Find
    (k "<leader>fe"
      (lua "Snacks.explorer({ layout = { preset = 'default', preview = 'main' } })")
      "File explorer"
    )
    (k "<leader>ff" (lua "Snacks.picker.files()") "Files")
    (k "<leader>fg" (lua "Snacks.picker.grep()") "Grep")
    (k "<leader>fb" (lua "Snacks.picker.buffers()") "Buffers")
    (k "<leader>fr" (lua "Snacks.picker.recent()") "Recent files")
    (k "<leader>fh" (lua "Snacks.picker.help()") "Help")
    (k "<leader>fk" (lua "Snacks.picker.keymaps()") "Keymaps")
    (k "<leader>fc" (lua "Snacks.picker.command_history()") "Command history")
    (k "<leader>fu" (lua "Snacks.picker.undo()") "Undo history")
    (k "<leader>fs" (lua "Snacks.picker.lsp_symbols()") "Symbols in file")
    (k "<leader>fw" (lua "Snacks.picker.lsp_workspace_symbols()")
      "Symbols in workspace"
    )
    (k "<leader>fS"
      (lua "Snacks.picker.lsp_workspace_symbols({ pattern = vim.fn.expand('<cword>') })")
      "Symbol under cursor"
    )
    (k "<leader>fR" (cmd "GrugFar") "Search & replace in project")
    (inModes "v" (
      k "<leader>fR" "<esc><cmd>GrugFar<cr>" "Search & replace selection"
    ))

    # LSP
    (k "<leader>ld" (lua "Snacks.picker.lsp_definitions()") "Definition")
    (k "<leader>lD" (lua "vim.lsp.buf.declaration()") "Declaration")
    (k "<leader>li" (lua "Snacks.picker.lsp_implementations()") "Implementations")
    (k "<leader>lr" (lua "Snacks.picker.lsp_references()") "References")
    (k "<leader>lt" (lua "Snacks.picker.lsp_type_definitions()") "Type definition")
    (k "<leader>lh" (lua "vim.lsp.buf.hover()") "Hover")
    (k "<leader>lR" (cmd "lsp restart") "Restart servers")
    (k "<leader>ls" (cmd "LspRefresh") "Tell servers the file changed")
    (k "<leader>lH" (cmd "checkhealth vim.lsp") "Health")

    # Code
    (k "<leader>ca" (lua "vim.lsp.buf.code_action()") "Code action")
    (k "<leader>cr" (lua "vim.lsp.buf.rename()") "Rename symbol")
    (k "<leader>cR" (lua "Snacks.rename.rename_file()") "Rename file")
    (k "<leader>cf" (lua "require('conform').format()") "Format")
    (k "<leader>co"
      (lua "vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' }, diagnostics = {} }, apply = true })")
      "Organize imports"
    )
    (k "<leader>ch"
      (lua "vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })")
      "Toggle inlay hints"
    )
    (k "<leader>cl" (lua "vim.lsp.codelens.run()") "Run code lens")

    # Diagnostics and lists
    (k "[d" (jump (-1) null) "Previous diagnostic")
    (k "]d" (jump 1 null) "Next diagnostic")
    (k "[e" (jump (-1) "ERROR") "Previous error")
    (k "]e" (jump 1 "ERROR") "Next error")
    (k "[w" (jump (-1) "WARN") "Previous warning")
    (k "]w" (jump 1 "WARN") "Next warning")
    (k "<leader>xe" (lua "vim.diagnostic.open_float()") "Diagnostic at cursor")
    (k "<leader>xf" (lua "Snacks.picker.diagnostics_buffer()")
      "Diagnostics in file"
    )
    (k "<leader>xa" (lua "Snacks.picker.diagnostics()") "All diagnostics")
    (k "<leader>xq" (lua "Snacks.picker.qflist()") "Quickfix list")
    (k "<leader>xl" (lua "Snacks.picker.loclist()") "Location list")

    # Git: hunks (gitsigns)
    (k "]h" (lua "require('gitsigns').nav_hunk('next')") "Next hunk")
    (k "[h" (lua "require('gitsigns').nav_hunk('prev')") "Previous hunk")
    (k "<leader>gh" (lua "require('gitsigns').preview_hunk()") "Preview hunk")
    (k "<leader>gs" (lua "require('gitsigns').stage_hunk()") "Stage/unstage hunk")
    (k "<leader>gr" (lua "require('gitsigns').reset_hunk()") "Reset hunk")
    (k "<leader>gS" (lua "require('gitsigns').stage_buffer()") "Stage file")
    (k "<leader>gR" (lua "require('gitsigns').reset_buffer()") "Reset file")
    (k "<leader>gb" (lua "require('gitsigns').blame_line({ full = true })")
      "Blame line"
    )
    (k "<leader>gt" (lua "require('gitsigns').toggle_current_line_blame()")
      "Toggle inline blame"
    )
    (k "<leader>gd" (lua "require('gitsigns').diffthis()")
      "Diff file against index"
    )
    (inModes [ "o" "x" ] (k "ih" (lua "require('gitsigns').select_hunk()") "Hunk"))
    # Git: repository (snacks pickers, diffview)
    (k "<leader>gg" (lua "Snacks.picker.git_status()") "Status")
    (k "<leader>gl" (lua "Snacks.picker.git_log()") "Log")
    (k "<leader>gB" (lua "Snacks.picker.git_branches()") "Branches")
    (k "<leader>go" (lua "Snacks.gitbrowse()") "Open in browser")
    (k "<leader>gD" (cmd "DiffviewOpen") "Diff working tree (diffview)")
    (k "<leader>gc" (prompt "Compare with ref" "HEAD"
      "vim.cmd('DiffviewOpen ' .. input)"
    ) "Diff against a ref")
    (k "<leader>gH" (cmd "DiffviewFileHistory %") "File history")
    (k "<leader>gL" (cmd "DiffviewFileHistory") "Branch history")
    (k "<leader>gq" (cmd "DiffviewClose") "Close diffview")

  ]
  # Test (neotest; enabled by languages with a test adapter)
  ++ onlyIf config.plugins.neotest.enable [
    (k "<leader>tt" (lua "${neotest}.run.run()") "Nearest")
    (k "<leader>tf" (lua "${neotest}.run.run(vim.fn.expand('%'))") "File")
    (k "<leader>ta" (lua "${neotest}.run.run(vim.fn.getcwd())") "All")
    (k "<leader>tl" (lua "${neotest}.run.run_last()") "Last")
    (k "<leader>td" (lua "${neotest}.run.run({ strategy = 'dap' })")
      "Debug nearest"
    )
    (k "<leader>tx" (lua "${neotest}.run.stop()") "Stop")
    (k "<leader>tw" (lua "${neotest}.watch.toggle(vim.fn.expand('%'))")
      "Watch file"
    )
    (k "<leader>ts" (lua "${neotest}.summary.toggle()") "Summary")
    (k "<leader>to"
      (lua "${neotest}.output.open({ enter = true, auto_close = true })")
      "Output of last run"
    )
    (k "<leader>tp" (lua "${neotest}.output_panel.toggle()") "Output panel")

  ]
  # Debug (dap, dap-view; enabled by languages with a debugger)
  ++ onlyIf config.plugins.dap.enable [
    (k "<leader>db" (lua "require('dap').toggle_breakpoint()") "Toggle breakpoint")
    (k "<leader>dB" (prompt "Breakpoint condition" ""
      "require('dap').set_breakpoint(input)"
    ) "Conditional breakpoint")
    (k "<leader>dc" (lua "require('dap').continue()") "Start / continue")
    (k "<leader>dn" (lua "require('dap').step_over()") "Step over")
    (k "<leader>di" (lua "require('dap').step_into()") "Step into")
    (k "<leader>do" (lua "require('dap').step_out()") "Step out")
    (k "<leader>dC" (lua "require('dap').run_to_cursor()") "Run to cursor")
    (k "<leader>dl" (lua "require('dap').run_last()") "Run last")
    (k "<leader>dq" (lua "require('dap').terminate()") "Terminate")
    (k "<leader>dv" (lua "require('dap-view').toggle()") "Toggle panels")
    (k "<leader>dw" (lua "require('dap-view').add_expr()")
      "Watch expression under cursor"
    )
    (k "<leader>dr" (lua "require('dap-view').jump_to_view('repl')") "REPL")
    (k "<leader>dh" (lua "require('dap.ui.widgets').hover()")
      "Inspect under cursor"
    )

  ]
  ++ [
    # AI (claudecode)
    (k "<leader>aa" (cmd "ClaudeCode") "Toggle Claude")
    (k "<leader>af" (cmd "ClaudeCodeFocus") "Focus Claude")
    (k "<leader>ar" (cmd "ClaudeCode --resume") "Resume a conversation")
    (k "<leader>ac" (cmd "ClaudeCode --continue") "Continue last conversation")
    (k "<leader>ab" (cmd "ClaudeCodeAdd %") "Add file to context")
    (inModes "v" (k "<leader>as" (cmd "ClaudeCodeSend") "Send selection"))
    (k "<leader>ay" (cmd "ClaudeCodeDiffAccept") "Accept proposed diff")
    (k "<leader>an" (cmd "ClaudeCodeDiffDeny") "Reject proposed diff")
    # Back out of the Claude terminal without leaving terminal mode first
    (inModes "t" (k "<C-a>" (cmd "ClaudeCode") "Toggle Claude"))

    # Markdown
    (k "<leader>mr" (lua "require('render-markdown').toggle()") "Toggle rendering")

    # Motions (flash); visual S stays nvim-surround's
    (inModes [ "n" "x" "o" ] (k "s" (lua "require('flash').jump()") "Flash jump"))
    (inModes [ "n" "o" ] (
      k "S" (lua "require('flash').treesitter()") "Flash treesitter select"
    ))
    (inModes "o" (k "r" (lua "require('flash').remote()") "Flash remote"))
    (inModes [ "o" "x" ] (
      k "R" (lua "require('flash').treesitter_search()") "Flash treesitter search"
    ))
    (inModes "c" (
      k "<C-s>" (lua "require('flash').toggle()") "Toggle flash in search"
    ))
  ];

  # Buffer-local maps: set when a buffer matches `event`/`pattern`
  local = [
    {
      name = "rust";
      when = config.languages.rust.enable;
      event = "FileType";
      pattern = "rust";
      group = {
        prefix = "<leader>r";
        name = "Rust";
      };
      maps = [
        (k "K" (lua "vim.cmd.RustLsp({ 'hover', 'actions' })") "Hover actions")
        (k "<leader>ca" (lua "vim.cmd.RustLsp('codeAction')") "Code action (grouped)")
        (k "<leader>dd" (lua "vim.cmd.RustLsp('debuggables')") "Debuggables")
        (k "<leader>rr" (lua "vim.cmd.RustLsp('runnables')") "Runnables")
        (k "<leader>re" (lua "vim.cmd.RustLsp('expandMacro')") "Expand macro")
        (k "<leader>rc" (lua "vim.cmd.RustLsp('openCargo')") "Open Cargo.toml")
        (k "<leader>rp" (lua "vim.cmd.RustLsp('parentModule')") "Parent module")
        (k "<leader>rj" (lua "vim.cmd.RustLsp('joinLines')") "Join lines")
        (k "<leader>rx" (lua "vim.cmd.RustLsp('explainError')") "Explain error")
        (k "<leader>rD" (lua "vim.cmd.RustLsp('renderDiagnostic')") "Render diagnostic")
        (k "<leader>rK" (lua "vim.cmd.RustLsp({ 'moveItem', 'up' })") "Move item up")
        (k "<leader>rJ" (lua "vim.cmd.RustLsp({ 'moveItem', 'down' })")
          "Move item down"
        )
      ];
    }
    {
      name = "crates";
      when = config.languages.rust.enable;
      event = "BufRead";
      pattern = "Cargo.toml";
      group = {
        prefix = "<leader>C";
        name = "Crates";
      };
      maps = map (m: k m.key (lua "require('crates').${m.fn}()") m.desc) [
        {
          key = "<leader>Ct";
          fn = "toggle";
          desc = "Toggle info";
        }
        {
          key = "<leader>Cr";
          fn = "reload";
          desc = "Reload";
        }
        {
          key = "<leader>Cv";
          fn = "show_versions_popup";
          desc = "Versions";
        }
        {
          key = "<leader>Cf";
          fn = "show_features_popup";
          desc = "Features";
        }
        {
          key = "<leader>Cd";
          fn = "show_dependencies_popup";
          desc = "Dependencies";
        }
        {
          key = "<leader>Cu";
          fn = "update_crate";
          desc = "Update crate";
        }
        {
          key = "<leader>CU";
          fn = "update_all_crates";
          desc = "Update all";
        }
        {
          key = "<leader>Cg";
          fn = "upgrade_crate";
          desc = "Upgrade crate";
        }
        {
          key = "<leader>CG";
          fn = "upgrade_all_crates";
          desc = "Upgrade all";
        }
        {
          key = "<leader>Co";
          fn = "open_documentation";
          desc = "Open docs";
        }
        {
          key = "<leader>Ch";
          fn = "open_homepage";
          desc = "Open homepage";
        }
      ];
    }
  ];

  # Insert-mode completion keys (blink.cmp)
  completion = {
    preset = "default";
    "<C-n>" = [
      "select_next"
      "fallback"
    ];
    "<C-p>" = [
      "select_prev"
      "fallback"
    ];
    "<C-j>" = [
      "select_next"
      "fallback"
    ];
    "<C-k>" = [
      "select_prev"
      "fallback"
    ];
    "<Down>" = [
      "select_next"
      "fallback"
    ];
    "<Up>" = [
      "select_prev"
      "fallback"
    ];
    "<C-d>" = [
      "scroll_documentation_down"
      "fallback"
    ];
    "<C-u>" = [
      "scroll_documentation_up"
      "fallback"
    ];
    "<C-y>" = [
      "select_and_accept"
      "fallback"
    ];
    "<C-e>" = [
      "cancel"
      "fallback"
    ];
    "<C-Space>" = [
      "show"
      "show_documentation"
      "hide_documentation"
    ];
    "<CR>" = [
      "accept"
      "fallback"
    ];
    "<Tab>" = [
      "snippet_forward"
      "select_next"
      "fallback"
    ];
    "<S-Tab>" = [
      "snippet_backward"
      "select_prev"
      "fallback"
    ];
  };

  # Keys inside neotest's summary window
  testSummary = {
    expand = [
      "<CR>"
      "<2-LeftMouse>"
    ];
    jumpto = "i";
    run = "r";
    debug = "d";
    stop = "u";
    watch = "w";
  };

  # --- rendering ---------------------------------------------------------
  modesOf = e: lib.toList (e.mode or "n");
  activeGlobal = lib.filter (e: e.when or true) global;
  activeLocal = lib.filter (s: s.when) local;

  duplicates =
    entries:
    let
      ids = lib.concatMap (e: map (m: "${m} ${e.key}") (modesOf e)) entries;
    in
    lib.unique (lib.filter (id: lib.count (x: x == id) ids > 1) ids);

  setLocal = e: ''
    vim.keymap.set(${toLuaObject (modesOf e)}, ${toLuaObject e.key}, ${toLuaObject e.action}, { buffer = ev.buf, silent = true, desc = ${toLuaObject e.desc} })
  '';
in
{
  keymaps = map (e: {
    mode = modesOf e;
    inherit (e) key action;
    options = {
      inherit (e) desc;
      silent = true;
    };
  }) activeGlobal;

  autoGroups.local_keymaps.clear = true;
  autoCmd = map (s: {
    desc = "${s.name} keymaps";
    inherit (s) event pattern;
    group = "local_keymaps";
    callback.__raw = "function(ev)\nvim.b[ev.buf].local_keymaps_${s.name} = true\n${lib.concatMapStrings setLocal s.maps}end";
  }) activeLocal;

  plugins.which-key.settings.spec =
    lib.mapAttrsToList
      (prefix: name: {
        __unkeyed-1 = prefix;
        group = name;
      })
      (
        groups
        // lib.optionalAttrs config.plugins.neotest.enable { "<leader>t" = "Test"; }
        // lib.optionalAttrs config.plugins.dap.enable { "<leader>d" = "Debug"; }
      )
    ++ map (s: {
      __unkeyed-1 = s.group.prefix;
      group = s.group.name;
      cond.__raw = "function() return vim.b.local_keymaps_${s.name} == true end";
    }) activeLocal;

  plugins.blink-cmp.settings.keymap = completion;
  plugins.neotest.settings.summary.mappings = testSummary;

  assertions =
    map
      (scope: {
        assertion = duplicates scope.maps == [ ];
        message = "keymaps.nix: ${scope.name} maps the same key twice: ${toString (duplicates scope.maps)}";
      })
      (
        [
          {
            name = "global";
            maps = activeGlobal;
          }
        ]
        ++ activeLocal
      );
}
