local secret = require("vars.secret")

return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup({
        provider = "openai_compatible",
        request_timeout = 2,
        throttle = 1500, -- Increase to reduce costs and avoid rate limits
        debounce = 600, -- Increase to reduce costs and avoid rate limits
        notify = "debug",
        provider_options = {
          openai_compatible = {
            name = "minuet",
            end_point = "https://worklink.yealink.com/llmproxy/v1/chat/completions",
            api_key = function()
              return secret.worklink_llm
            end,
            model = "qwen2.5-coder-32b-instruct",
            stream = true,
            optional = {
              max_tokens = 4096,
              temperature = 0.01,
              top_p = 0.2,
              provider = {
                sort = "throughput",
              },
              stop = { "\n\n" },
            },
          },
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
