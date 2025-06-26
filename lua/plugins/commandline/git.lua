local M = {}

-- Configuration storage
local config = {
  openai_base_url = nil,
  openai_key = nil,
  model = nil,
}

local function run_in_terminal(cmd, title)
  local term_cmd = "terminal " .. cmd
  vim.cmd("botright split")
  vim.cmd("resize 15")
  vim.cmd(term_cmd)
  vim.cmd("setlocal nonumber norelativenumber")
  if title then
    vim.cmd("file " .. title)
  end
end

function M.ai_commit()
  vim.cmd("w")

  local cmds = { "aicommit" }

  -- Check if configuration is set
  if not config.openai_base_url or not config.openai_key or not config.model then
    print("[GitAICommit Error] Configuration not set. Please run :GitAICommitConfig first")
    return
  end

  -- Add configuration parameters
  table.insert(cmds, "--openai-base-url")
  table.insert(cmds, config.openai_base_url)
  table.insert(cmds, "--openai-key")
  table.insert(cmds, config.openai_key)
  table.insert(cmds, "--model")
  table.insert(cmds, config.model)

  local cmd = table.concat(cmds, " ")
  print("[GitAICommit CMD] " .. cmd:gsub(config.openai_key, "***")) -- Hide API key in output
  run_in_terminal(cmd, "GitAICommit")
end

function M.configure()
  -- Prompt for configuration
  local base_url = vim.fn.input("OpenAI Base URL: ", config.openai_base_url or "https://api.openai.com/v1")
  if base_url == "" then
    return
  end

  local api_key = vim.fn.input("OpenAI API Key: ", config.openai_key or "")
  if api_key == "" then
    return
  end

  local model = vim.fn.input("Model: ", config.model or "gpt-3.5-turbo")
  if model == "" then
    return
  end

  -- Save configuration
  config.openai_base_url = base_url
  config.openai_key = api_key
  config.model = model

  print("\n[GitAICommit] Configuration saved successfully!")
  print("Base URL: " .. base_url)
  print("Model: " .. model)
  print("API Key: ***")
end

function M.setup()
  vim.api.nvim_create_user_command("GitAICommit", function()
    M.ai_commit()
  end, {
    desc = "Generate AI commit message using aicommit",
  })

  vim.api.nvim_create_user_command("GitAICommitConfig", function()
    M.configure()
  end, {
    desc = "Configure GitAICommit settings (base URL, API key, model)",
  })
end

return M

