return {
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
      indent = {
        scope = { enabled = false },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    enabled = false,
    opts = {
      stiffness = 0.6,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.1,
    },
  },
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup()
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },
}
