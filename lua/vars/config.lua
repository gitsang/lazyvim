local env = require("vars.environment")

return {
  codecompanion = {
    language = env and env.secret and env.config.codecompanion.language or "English",
    chat = {
      adapter = env and env.secret and env.config.codecompanion.chat.adapter or "changeit",
    },
    inline = {
      adapter = env and env.secret and env.config.codecompanion.inline.adapter or "changeit",
    },
    cmd = {
      adapter = env and env.secret and env.config.codecompanion.cmd.adapter or "changeit",
    },
  },
  net_interface = env and env.secret and env.config.net_interface or "eth0",
  default_browser = env and env.secret and env.config.default_browser or "none",
}
