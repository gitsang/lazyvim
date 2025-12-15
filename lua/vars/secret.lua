local env = require("vars.environment")

return {
  yllm = env and env.secret and env.secret.yllm or "changeit",
  zai = env and env.secret and env.secret.zai or "changeit",
  siliconflow = env and env.secret and env.secret.siliconflow or "changeit",
  aihubmix = env and env.secret and env.secret.aihubmix or "changeit",
  openrouter = env and env.secret and env.secret.openrouter or "changeit",
  modelscope = env and env.secret and env.secret.modelscope or "changeit",
  github = env and env.secret and env.secret.github or "changeit",
  github_pat = env and env.secret and env.secret.github_pat or "changeit",
}
