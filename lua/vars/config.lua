local function with_defaults(obj, defaults)
  return setmetatable({}, {
    __index = function(_, key)
      return obj[key] or defaults[key]
    end,
  })
end

local function load_environments()
  local success, env = pcall(require, "vars.env")
  return success and env or {}
end

local env = load_environments()
local env_config = with_defaults(env.config or {}, {
  codecompanion = {
    language = "English",
    chat = {
      adapter = "changeit",
    },
    inline = {
      adapter = "changeit",
    },
    cmd = {
      adapter = "changeit",
    },
  },
  net_interface = "eth0",
  default_browser = "none",
  llama = {
    endpoint = "http://localhost:8012/infill",
  },
})

return env_config
