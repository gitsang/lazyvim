return {
  {
    "gitsang/trzsz.nvim",
    opts = {
      width = 60,
      trz_cmd = "trz",
    },
    cmd = { "Trz", "Tsz" },
    keys = {
      { "<leader>tu", "<cmd>Trz<cr>", desc = "Upload files with trz" },
    },
  },
}
