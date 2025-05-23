local secret = require("vars.secret")

local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "openrouter",
    env = {
      url = "https://openrouter.ai/api/v1",
      api_key = secret.openrouter,
    },
    schema = {
      model = {
        default = "tngtech/deepseek-r1t-chimera:free",
        choices = {
          "deepseek/deepseek-r1:free", -- 164K Context
          "tngtech/deepseek-r1t-chimera:free", -- 164K Context
          "google/gemma-3-27b-it:free", -- 96K Context
          "google/gemini-2.0-flash-exp:free", -- 10.5K Context
          "qwen/qwen2.5-vl-72b-instruct:free", -- 131K Context
        },
      },
    },
  })
end

return M
