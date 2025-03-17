local minuet = require("vars.minuet-ai")

return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        request_timeout = 2,
        throttle = 1500, -- Increase to reduce costs and avoid rate limits
        debounce = 600, -- Increase to reduce costs and avoid rate limits
        notify = "verbose",
        provider_options = {
          openai_fim_compatible = minuet.openai_fim_compatible,
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "minuet",
        group_index = 1,
        priority = 100,
      })
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<A-y>"] = require("minuet").make_cmp_map(),
      })
    end,
  },
}
