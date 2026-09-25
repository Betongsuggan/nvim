# Markdown rendered in the editor (headings, code blocks, checkboxes, tables),
# loaded with the first markdown buffer; its default icons are used.
{ ... }:
{
  plugins.render-markdown = {
    enable = true;
    lazyLoad.settings.ft = "markdown";
    settings.code.border = "thin";
  };
}
