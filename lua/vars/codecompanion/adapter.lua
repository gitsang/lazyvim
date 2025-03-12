local secret = require("vars.secret")

return {
  worklink_deepseek = function()
    return require("codecompanion.adapters").extend("deepseek", {
      url = "https://worklink.yealink.com/llmproxy/v1/chat/completions",
      env = {
        api_key = secret.worklink_llm,
      },
      schema = {
        model = {
          default = "deepseek-v3",
          choices = {
            ["deepseek-r1"] = { opts = { can_reason = true } },
            "deepseek-v3",
          },
        },
      },
    })
  end,
  worklink_openai = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      env = {
        url = "https://worklink.yealink.com/llmproxy/",
        api_key = secret.worklink_llm,
      },
      schema = {
        model = {
          default = "gpt-4o",
          choices = {
            "gpt-4o",
            "gpt-4o-mini",
            "gpt-3.5-turbo",
            "gpt-3.5-turbo-16k",
            "qwen-turbo-0624",
          },
        },
      },
    })
  end,
  worklink_ollama = function()
    return require("codecompanion.adapters").extend("ollama", {
      env = {
        url = "http://10.5.204.206:11434",
      },
      schema = {
        model = {
          default = "qwq:latest",
          choices = {
            "qwq:latest",
            "deepseek-r1:32b",
          },
        },
      },
    })
  end,
  siliconflow = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
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
          },
        },
      },
    })
  end,
  sang_ollama = function()
    return require("codecompanion.adapters").extend("ollama", {
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
