local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "worklink",
    env = {
      url = "https://worklink.yealink.com/llmproxy",
      api_key = require("vars.secret").worklink_llm,
    },
    schema = {
      model = {
        default = require("vars.environment").codecompanion.default_model,
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
          "claude-4.0-sonnet",
        },
      },
    },
  })
end

return M
