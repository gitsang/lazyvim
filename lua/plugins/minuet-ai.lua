local secret = require("vars.secret")

local cmp = require("cmp")

table.insert(cmp.opts.sources, 1, {
  name = "minuet",
  group_index = 1,
  priority = 100,
})

return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("minuet").setup({
      provider = "openai_compatible",
      request_timeout = 10,
      throttle = 15000, -- Increase to reduce costs and avoid rate limits
      debounce = 6000, -- Increase to reduce costs and avoid rate limits
      notify = "debug",
      provider_options = {
        openai_compatible = {
          name = "Worklink",
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
              -- Prioritize throughput for faster completion
              sort = "throughput",
            },
            stop = { "\n\n" },
          },
        },
      },
    })
  end,
}
