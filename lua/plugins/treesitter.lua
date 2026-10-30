local function read_scm_file(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return "Could not open file: " .. filepath
  end

  local content = file:read("*a")
  file:close()

  return content
end

local HOME = os.getenv("HOME")

-- EL9 (AlmaLinux / Rocky Linux) compatibility note:
-- The system GLIBC is 2.34, but the tree-sitter-cli prebuilt binary installed
-- by Mason or npm requires GLIBC_2.39 and cannot run. The new nvim-treesitter
-- (main branch) depends entirely on the system tree-sitter CLI, so it must be
-- compiled from source via Cargo:
--
--   # Install bindgen dependency (required to generate C bindings)
--   dnf install -y clang-devel clang-libs
--
--   # Build and install from source (ensure ~/.cargo/bin is in PATH)
--   cargo install tree-sitter-cli
--
-- Then remove the incompatible Mason binary to prevent it from taking priority:
--   rm -rf ~/.local/share/nvim/mason/packages/tree-sitter-cli
--   rm -f  ~/.local/share/nvim/mason/bin/tree-sitter

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- https://github.com/MeanderingProgrammer/render-markdown.nvim/discussions/370#discussioncomment-12555901
      vim.treesitter.query.set(
        "markdown_inline",
        "highlights",
        read_scm_file(HOME .. "/.config/nvim/lua/plugins/treesitter/queries/markdown_inline/highlights.scm")
      )
      vim.treesitter.query.set(
        "markdown",
        "highlights",
        read_scm_file(HOME .. "/.config/nvim/lua/plugins/treesitter/queries/markdown/highlights.scm")
      )

      -- Link destinations are kept visible (see the custom markdown_inline query),
      -- so give them their own color: the default '@markup.link.url' only links to
      -- 'Underlined', which has no foreground color. Use the colorscheme's 'Comment'
      -- color + underline so the '(url)' part stands apart from the link text.
      local function color_url()
        local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
        vim.api.nvim_set_hl(0, "@markup.link.url", {
          fg = comment.fg,
          ctermfg = comment.ctermfg,
          underline = true,
        })
      end
      color_url()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("UserMarkdownUrlColor", { clear = true }),
        callback = color_url,
      })
    end,
  },
}
