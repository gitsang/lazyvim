local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "zai",
    env = {
      url = "https://api.z.ai/api/coding/paas/v4/chat/completions",
      api_key = require("vars.secret").zai,
    },
    headers = {
      ["User-Agent"] = "CodeCompanion.nvim",
    },
    schema = {
      model = {
        default = "glm-4.6",
        choices = {
          "glm-4.6",
          "glm-4.5",
        },
      },
    },
  })
end

return M
