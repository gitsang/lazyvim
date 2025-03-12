return {
  {
    "Exafunction/codeium.vim",
    branch = "main",
    config = function()
      vim.g.codeium_no_map_tab = 1
      -- vim.keymap.set("i", "<C-g>", function()
      --   return vim.fn["codeium#Accept"]()
      -- end, { expr = true, script = true, silent = true, nowait = true })
      -- vim.keymap.set("i", "<C-;>", "<Cmd>call codeium#CycleCompletions(1)<CR>", {})
      -- vim.keymap.set("i", "<C-,>", "<Cmd>call codeium#CycleCompletions(-1)<CR>", {})
      -- vim.keymap.set("i", "<C-x>", "<Cmd>call codeium#Clear()<CR>", {})
    end,
  },
}
