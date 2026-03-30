return {
  {
    "gitsang/trzsz.nvim",
    opts = {
      trz_cmd = "trz",
      tsz_cmd = "tsz -y",
    },
    cmd = { "Trz", "Tsz" },
    keys = {
      { "<leader>tu", "<cmd>Trz<cr>", desc = "Upload files with trz" },
      { "<leader>td", "<cmd>Tsz<cr>", desc = "Download files with trz" },
    },
  },
}
