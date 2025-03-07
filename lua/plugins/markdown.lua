local function get_first_ip(interface)
  local handle = io.popen("ip -4 addr show " .. interface .. " | grep inet | awk '{print $2}' | cut -d/ -f1")
  if not handle then
    return nil
  end
  local result = handle:read("*a")
  handle:close()
  return result and result:match("%d+%.%d+%.%d+%.%d+")
end

local default_browser = require("vars.environment").default_browser
local net_interface = require("vars.environment").net_interface
local main_ip = get_first_ip(net_interface)

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<F8>",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 1
      vim.g.mkdp_open_ip = main_ip
      vim.g.mkdp_port = "7777"
      vim.g.mkdp_browser = default_browser
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  {
    "mzlogin/vim-markdown-toc",
    config = function()
      vim.g.vmt_auto_update_on_save = 1
      vim.g.vmt_dont_insert_fence = 0
      vim.g.vmt_fence_text = "markdown-toc"
      vim.g.vmt_fence_closing_text = "/markdown-toc"
      vim.g.vmt_fence_hidden_markdown_style = ""
      vim.g.vmt_cycle_list_item_markers = 0
      vim.g.vmt_list_item_char = "-"
      vim.g.vmt_include_headings_before = 0
      vim.g.vmt_list_indent_text = "  "
      vim.g.vmt_link = 1
      vim.g.vmt_min_level = 1
      vim.g.vmt_max_level = 6
    end,
  },
}
