return {
  "gbprod/yanky.nvim",
  opts = {},
  dependencies = { "folke/snacks.nvim" },
  keys = {
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
  config = function(_, opts)
    require("yanky").setup(opts)

    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = function()
        vim.cmd("wshada")
      end,
    })

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.cmd("rshada")
      end,
    })
    vim.opt.updatetime = 200
  end,
}
