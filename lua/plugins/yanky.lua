return {
  "gbprod/yanky.nvim",
  opts = {},
  dependencies = { "folke/snacks.nvim" },
  keys = {
    {
      "<leader>p",
      function()
        ---@diagnostic disable-next-line: undefined-field
        Snacks.picker.yanky()
      end,
      desc = "Open Yank History",
    },
  },
}
