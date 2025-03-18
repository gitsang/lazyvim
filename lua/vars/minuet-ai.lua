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

local ollama_endpoint = "http://10.5.204.206:11434/v1/completions"
local function ollama_openai_fim_compatible(name, model)
  return openai_fim_compatible(name, ollama_endpoint, "TERM", model, false, default_optional)
end

local openai_fim_compatible_map = {
  worklink_qwen = worklink_openai_fim_compatible("qwen2.5-coder:32b", "qwen2.5-coder-32b-instruct"),
  aihubmix_claude = aihubmix_openai_fim_compatible("claude3.5-haiku", "claude-3-5-haiku-20241022"),
  ollama_qwen = ollama_openai_fim_compatible("qwen2.5-coder:7b", "qwen2.5-coder:7b"),
}

return {
  openai_fim_compatible = openai_fim_compatible_map[require("vars.environment").minuet.adapter],
}
