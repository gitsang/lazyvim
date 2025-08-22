return {
  "gbprod/yanky.nvim",
  opts = {},
  dependencies = { "folke/snacks.nvim" },
  keys = {
    {
      "y",
      function()
        local keys = vim.api.nvim_replace_termcodes("<Plug>(YankyYank)", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end,
      desc = "Yanky PutAfter",
    },
    {
      "p",
      function()
        vim.cmd("rshada")
        local keys = vim.api.nvim_replace_termcodes("<Plug>(YankyPutAfter)", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end,
      desc = "Yanky PutAfter",
    },
    {
      "<leader>p",
      function()
        vim.cmd("rshada")
        ---@diagnostic disable-next-line: undefined-field
        Snacks.picker.yanky()
      end,
      desc = "Open Yank History",
    },
    { "<leader>SW", "<cmd>wshada<cr>", desc = "Write Shada" },
    { "<leader>SR", "<cmd>rshada<cr>", desc = "Read Shada" },
  },
}
