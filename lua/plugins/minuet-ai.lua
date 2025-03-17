local secret = require("vars.secret")

local default_stop = {
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
}

local default_optional = {
  max_tokens = 4096,
  temperature = 0.01,
  top_p = 0.2,
  provider = {
    sort = "throughput",
  },
  num_predict = 4096,
  num_ctx = 8192,
  stop = default_stop,
}

local function openai_fim_compatible(name, end_point, api_key, model, stream, optional)
  return {
    name = name,
    end_point = end_point,
    api_key = function()
      return api_key
    end,
    model = model,
    stream = stream,
    optional = optional,
  }
end

local worklink_endpoint = "https://worklink.yealink.com/llmproxy/v1/completions"
local worklink_api_key = secret.worklink_llm
local function worklink_openai_fim_compatible(name, model)
  return openai_fim_compatible(name, worklink_endpoint, worklink_api_key, model, true, default_optional)
end

local aihubmix_endpoint = "https://aihubmix.com"
local aihubmix_api_key = secret.aihubmix
local function aihubmix_openai_fim_compatible(name, model)
  return openai_fim_compatible(name, aihubmix_endpoint, aihubmix_api_key, model, true, default_optional)
end

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
          -- openai_fim_compatible = worklink_openai_fim_compatible("qwen2.5-coder:32b", "qwen2.5-coder-32b-instruct"),
          openai_fim_compatible = aihubmix_openai_fim_compatible("claude3.5-haiku", "claude-3-5-haiku-20241022"),
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
