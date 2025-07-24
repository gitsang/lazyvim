return {
  {
    "marcinjahn/gemini-cli.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    cmd = "Gemini",
    keys = {
      { "<leader>a/", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI" },
      { "<leader>aa", "<cmd>Gemini ask<cr>", desc = "Ask Gemini", mode = { "n", "v" } },
      { "<leader>af", "<cmd>Gemini add_file<cr>", desc = "Add File" },
    },
    config = true,
  },
  {
    "gitsang/qwen-code.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    cmd = "QwenCode",
    keys = {
      { "<leader>qq", "<cmd>QwenCode toggle<cr>", desc = "Toggle Qwen Code" },
      { "<leader>qa", "<cmd>QwenCode ask<cr>", desc = "Ask Qwen", mode = { "n", "v" } },
      { "<leader>qf", "<cmd>QwenCode add_file<cr>", desc = "Add File" },
    },
    config = true,
  },
}
