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
  temperature = 0.01,
  top_p = 0.2,
  suffix = "\n",
  max_tokens = 512,
  num_predict = 128,
  num_ctx = 128,
  provider = {
    sort = "throughput",
  },
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

local worklink_endpoint = "http://openai-proxy.ops.yl.c8g.top:8888/llmproxy/v1/completions"
local worklink_api_key = secret.worklink_llm
local function worklink_openai_fim_compatible(name, model)
  return openai_fim_compatible(name, worklink_endpoint, worklink_api_key, model, true, default_optional)
end

local aihubmix_endpoint = "https://aihubmix.com"
local aihubmix_api_key = secret.aihubmix
local function aihubmix_openai_fim_compatible(name, model)
  return openai_fim_compatible(name, aihubmix_endpoint, aihubmix_api_key, model, true, default_optional)
end

local siliconflow_endpoint = "https://api.siliconflow.cn/v1/completions"
local siliconflow_api_key = secret.siliconflow
local function siliconflow_openai_fim_compatible(name, model)
  return openai_fim_compatible(name, siliconflow_endpoint, siliconflow_api_key, model, true, default_optional)
end

local ollama_endpoint = "http://10.5.204.206:11434/v1/completions"
local function ollama_openai_fim_compatible(name, model)
  return openai_fim_compatible(name, ollama_endpoint, "TERM", model, false, default_optional)
end

local openai_fim_compatible_map = {
  worklink_qwen_32b = worklink_openai_fim_compatible("qwen2.5-coder:32b", "qwen2.5-coder-32b-instruct"),
  worklink_qwen_14b = worklink_openai_fim_compatible("qwen2.5-coder:14b", "qwen2.5-coder-14b-instruct"),
  worklink_claude_haiku = worklink_openai_fim_compatible("claude-3.5-haiku", "claude-3.5-haiku"),
  worklink_claude_sonnet = worklink_openai_fim_compatible("claude-3.7-sonnet", "claude-3.7-sonnet"),
  aihubmix_claude = aihubmix_openai_fim_compatible("claude3.5-haiku", "claude-3-5-haiku-20241022"),
  aihubmix_qwen = aihubmix_openai_fim_compatible("qwen2.5-coder:32b", "Qwen/Qwen2.5-Coder-32B-Instruct"),
  sliconflow_qwen = siliconflow_openai_fim_compatible("qwen2.5-coder:32b", "Qwen/Qwen2.5-Coder-32B-Instruct"),
  ollama_qwen = ollama_openai_fim_compatible("qwen2.5-coder:7b", "qwen2.5-coder:7b"),
}

return {
  openai_fim_compatible = openai_fim_compatible_map[require("vars.environment").minuet.adapter],
}
