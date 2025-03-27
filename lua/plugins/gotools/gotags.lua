-- gotags.lua
local M = {}

local function log_error(message)
  print("[GoTags Debug] " .. message)
end

-- 添加tags的函数
function M.add_tags(start_line, end_line, ...)
  -- 保存文件
  vim.cmd("w")

  local filename = vim.fn.expand("%:t")
  local line = start_line .. "," .. end_line

  local cmds = { "gomodifytags" }
  table.insert(cmds, "-file")
  table.insert(cmds, filename)
  table.insert(cmds, "-line")
  table.insert(cmds, line)
  table.insert(cmds, "--skip-unexported")
  table.insert(cmds, "-w")
  table.insert(cmds, "--quiet")

  local args = { ... }

  -- 处理tags参数
  if args[1] and args[1] ~= "--" then
    table.insert(cmds, "-add-tags")
    table.insert(cmds, args[1])
  else
    table.insert(cmds, "-add-tags")
    table.insert(cmds, "json")
  end

  -- 处理options参数
  if args[2] and args[2] ~= "--" then
    table.insert(cmds, "-add-options")
    table.insert(cmds, args[2])
  else
    table.insert(cmds, "-add-options")
    table.insert(cmds, "json=omitempty")
  end

  -- 处理transform参数
  if args[3] and args[3] ~= "--" then
    table.insert(cmds, "-transform")
    table.insert(cmds, args[3])
  else
    table.insert(cmds, "-transform")
    table.insert(cmds, "camelcase")
  end

  -- 执行命令
  local cmd = table.concat(cmds, " ")
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  -- 检查命令执行是否成功
  if exit_code ~= 0 then
    log_error("Command failed: " .. cmd)
    log_error("Error: " .. result)
    return
  end

  -- 重新加载文件以显示更改
  vim.cmd("e!")
end

-- 移除tags的函数
function M.remove_tags(start_line, end_line, ...)
  -- 保存文件
  vim.cmd("w")

  local filename = vim.fn.expand("%:t")
  local line = start_line .. "," .. end_line

  local cmds = { "gomodifytags" }
  table.insert(cmds, "-file")
  table.insert(cmds, filename)
  table.insert(cmds, "-line")
  table.insert(cmds, line)
  table.insert(cmds, "-transform")
  table.insert(cmds, "camelcase")
  table.insert(cmds, "--skip-unexported")
  table.insert(cmds, "-w")
  table.insert(cmds, "--quiet")

  local args = { ... }

  -- 处理tags参数
  if args[1] and args[1] ~= "--" then
    table.insert(cmds, "-remove-tags")
    table.insert(cmds, args[1])
  else
    table.insert(cmds, "-remove-tags")
    table.insert(cmds, "json")
  end

  -- 处理options参数
  if args[2] and args[2] ~= "--" then
    table.insert(cmds, "-remove-options")
    table.insert(cmds, args[2])
  else
    table.insert(cmds, "-remove-options")
    table.insert(cmds, "json=omitempty")
  end

  -- 执行命令
  local cmd = table.concat(cmds, " ")
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  -- 检查命令执行是否成功
  if exit_code ~= 0 then
    log_error("Command failed: " .. cmd)
    log_error("Error: " .. result)
    return
  end

  -- 重新加载文件以显示更改
  vim.cmd("e!")
end

-- 设置用户命令
function M.setup()
  -- 定义添加标签的命令
  vim.api.nvim_create_user_command("GoTagsAdd", function(opts)
    M.add_tags(opts.line1, opts.line2, unpack(opts.fargs))
  end, {
    range = true,
    nargs = "*",
    desc = "Add tags to Go structs",
  })

  -- 定义删除标签的命令
  vim.api.nvim_create_user_command("GoTagsRemove", function(opts)
    M.remove_tags(opts.line1, opts.line2, unpack(opts.fargs))
  end, {
    range = true,
    nargs = "*",
    desc = "Remove tags from Go structs",
  })
end

return M
