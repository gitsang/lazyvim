return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      -- for virtual text at end of line
      virtual_text = {
        source = true,
      },
      -- for the floating diagnostics window when press `<leader>cd`
      float = {
        source = true,
      },
    },
  },
}
