local secret = require("vars.secret")

return {
  worklink = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      name = "worklink",
      env = {
        url = "https://worklink.yealink.com/llmproxy",
        api_key = secret.worklink_llm,
      },
      schema = {
        model = {
          default = "claude-3.7-sonnet",
          choices = {
            "gpt-4o",
            "gpt-4o-mini",
            "gpt-3.5-turbo",
            "gpt-3.5-turbo-16k",
            "qwen-turbo-0624",
            ["deepseek-r1"] = { opts = { can_reason = true } },
            "deepseek-v3",
            "claude-3.5-haiku",
            "claude-3.5-sonnet",
            "claude-3.7-sonnet",
          },
        },
      },
    })
  end,
  siliconflow = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      name = "siliconflow",
      env = {
        url = "https://api.siliconflow.cn/v1",
        api_key = secret.siliconflow,
      },
      schema = {
        model = {
          default = "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",
          choices = {
            "deepseek-ai/DeepSeek-R1", -- ￥4/￥16
            "deepseek-ai/DeepSeek-V3", -- ￥2/￥8
            "Qwen/QwQ-32B", -- ￥1/￥4
            "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B", -- Free
            "Qwen/Qwen2.5-7B-Instruct", -- Free
          },
        },
      },
    })
  end,
  aihubmix = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      name = "aihubmix",
      env = {
        url = "https://aihubmix.com",
        api_key = secret.aihubmix,
      },
      schema = {
        model = {
          default = "DeepSeek-R1",
          choices = {
            "DeepSeek-R1", -- $0.62/$2.48
            "DeepSeek-V3", -- $0.4/$1.6
            "Qwen/QwQ-32B", -- $0.14/$0.56
            "claude-3-5-haiku-20241022", -- $1.1/$5.5
            "claude-3-7-sonnet-20250219", -- $3.3/$16.5
          },
        },
      },
    })
  end,
  sang = function()
    return require("codecompanion.adapters").extend("ollama", {
      name = "sang",
      env = {
        url = "http://dev.xm1.c8g.top:11434",
      },
      schema = {
        model = {
          default = "deepseek-r1:14b",
          choices = {
            "deepseek-r1:14b",
          },
        },
      },
    })
  end,
}
