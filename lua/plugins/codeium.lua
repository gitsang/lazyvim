return {
  {
    "Exafunction/codeium.vim",
    enabled = true,
    branch = "main",
    config = function()
      vim.g.codeium_no_map_tab = 1
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, script = true, silent = true, nowait = true })
    end,
  },
}
