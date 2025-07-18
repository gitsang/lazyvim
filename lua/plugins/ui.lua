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
    enabled = true,
    opts = {
      stiffness = 0.6,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.1,
    },
  },
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup({
        debounce_threshold = {
          falling = 50,
          rising = 10,
        },
        hide = {
          cursorline = false,
          focused_win = false,
          only_win = false,
        },
        highlight = {
          groups = {
            InclineNormal = {
              default = true,
              group = "NormalFloat",
            },
            InclineNormalNC = {
              default = true,
              group = "NormalFloat",
            },
          },
        },
        ignore = {
          buftypes = "special",
          filetypes = {},
          floating_wins = true,
          unlisted_buffers = true,
          wintypes = "special",
        },
        render = "basic",
        window = {
          margin = {
            horizontal = 1,
            vertical = 1,
          },
          options = {
            signcolumn = "no",
            wrap = false,
          },
          overlap = {
            borders = true,
            statusline = false,
            tabline = false,
            winbar = false,
          },
          padding = 1,
          padding_char = " ",
          placement = {
            horizontal = "right",
            vertical = "top",
          },
          width = "fit",
          winhighlight = {
            active = {
              EndOfBuffer = "None",
              Normal = "InclineNormal",
              Search = "None",
            },
            inactive = {
              EndOfBuffer = "None",
              Normal = "InclineNormalNC",
              Search = "None",
            },
          },
          zindex = 50,
        },
      })
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },
}
