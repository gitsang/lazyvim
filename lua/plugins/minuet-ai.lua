local secret = require("vars.secret")

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
          openai_fim_compatible = {
            name = "qwen2.5-coder:32b",
            end_point = "https://worklink.yealink.com/llmproxy/v1/completions",
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
              num_predict = 4096,
              num_ctx = 8192,
              stop = {
                "<|endoftext|>",
                "<|fim_prefix|>",
                "<|fim_middle|>",
                "<|fim_suffix|>",
                "<|fim_pad|>",
                "<|repo_name|>",
                "<|file_sep|>",
                "<|im_start|>",
                "<|im_end|>",
                "/src/",
                "#- coding: utf-8",
                "```",
                "\n\n",
              },
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
