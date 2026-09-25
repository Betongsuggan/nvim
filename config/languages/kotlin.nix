# Kotlin specifics that don't fit the language registry.
{ ... }:
{
  # The JetBrains kotlin-lsp returns goto-definition results for stdlib and
  # dependency symbols as `jar:///path/to/foo.jar!/inner/Path.kt` URIs, which
  # Neovim can't open (an empty buffer, and pickers crash positioning the
  # cursor). Read the entry out of the archive instead (needs unzip).
  autoCmd = [
    {
      desc = "Read source entries from inside JAR archives (kotlin-lsp goto-def)";
      event = "BufReadCmd";
      pattern = "jar://*";
      callback.__raw = ''
        function(args)
          local uri = args.match
          -- Strip "jar:" / "zipfile:" scheme and optional "file://" prefix,
          -- collapse leading slashes. Result: "<absolute-jar-path>!/<inner>".
          local rest = uri:gsub("^jar:", ""):gsub("^zipfile:", ""):gsub("^file://", "")
          rest = rest:gsub("^/+", "/")
          local jar, inner = rest:match("^(.-)!/(.+)$")
          if not jar or not inner then
            vim.notify("Could not parse jar URI: " .. uri, vim.log.levels.ERROR, { title = "jar" })
            return
          end

          local lines = vim.fn.systemlist({ "unzip", "-p", jar, inner })
          if vim.v.shell_error ~= 0 then
            vim.notify("unzip failed for " .. inner .. " in " .. jar, vim.log.levels.ERROR, { title = "jar" })
            return
          end

          vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
          vim.bo[args.buf].modifiable = false
          vim.bo[args.buf].readonly = true
          vim.bo[args.buf].buftype = "nofile"
          vim.bo[args.buf].swapfile = false
          local ft = vim.filetype.match({ filename = inner })
          if ft then
            vim.bo[args.buf].filetype = ft
          end
        end
      '';
    }
  ];
}
