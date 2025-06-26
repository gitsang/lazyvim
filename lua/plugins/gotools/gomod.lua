local M = {}

function M.tidy()
  vim.cmd("w")

  local cmd = "go mod tidy"
  print("[GoMod CMD] " .. cmd)

  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    print("[GoMod Error] " .. result)
    return
  end

  print("[GoMod] Module tidied successfully")
end

function M.setup()
  vim.api.nvim_create_user_command("GoModTidy", function()
    M.tidy()
  end, {
    desc = "Run go mod tidy to clean up module dependencies",
  })
end

return M

