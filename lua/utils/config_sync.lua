-- Utility module for syncing configuration files
local M = {}

-- Function to sanitize config content to create safe examples
local function sanitize_config(content)
  -- Replace string values with placeholders
  local sanitized = content:gsub('([%w_]+)%s*=%s*"([^"]*)"', function(key, _)
    return key .. ' = "YOUR_' .. string.upper(key) .. '_HERE"'
  end)

  sanitized = sanitized:gsub("([%w_]+)%s*=%s*'([^']*)'", function(key, _)
    return key .. " = 'YOUR_" .. string.upper(key) .. "_HERE'"
  end)

  -- Handle multiline strings
  sanitized = sanitized:gsub("([%w_]+)%s*=%s*%[%[([^%]%]]*)%]%]", function(key, _)
    return key .. " = [[YOUR_" .. string.upper(key) .. "_HERE]]"
  end)

  return sanitized
end

-- Function to sync all config files in vars directory
M.sync_config = function()
  local vars_dir = vim.fn.expand("~/.config/nvim/lua/vars")
  local files = vim.fn.glob(vars_dir .. "/*.lua", false, true)

  for _, file_path in ipairs(files) do
    -- Skip example files
    if not file_path:match("%.example%.lua$") then
      local base_name = vim.fn.fnamemodify(file_path, ":t")
      local example_path = vars_dir .. "/" .. vim.fn.fnamemodify(base_name, ":r") .. ".example.lua"

      -- Read current config
      local config_file = io.open(file_path, "r")
      if not config_file then
        vim.notify("Could not open file: " .. file_path, vim.log.levels.ERROR)
        goto continue
      end

      local config_content = config_file:read("*all")
      config_file:close()

      -- Sanitize content to create safe example
      local example_content = sanitize_config(config_content)

      -- Write to example file
      local example_file = io.open(example_path, "w")
      if example_file then
        example_file:write(example_content)
        example_file:close()
        vim.notify("Synced " .. base_name .. " to " .. vim.fn.fnamemodify(example_path, ":t"), vim.log.levels.INFO)
      else
        vim.notify("Failed to open for writing: " .. example_path, vim.log.levels.ERROR)
      end

      ::continue::
    end
  end
end

-- Function to sync a specific file
M.sync_file = function(file_path)
  if not file_path:match("%.example%.lua$") and file_path:match("/vars/") then
    local vars_dir = vim.fn.expand("~/.config/nvim/lua/vars")
    local base_name = vim.fn.fnamemodify(file_path, ":t")
    local example_path = vars_dir .. "/" .. vim.fn.fnamemodify(base_name, ":r") .. ".example.lua"

    -- Read current config
    local config_file = io.open(file_path, "r")
    if not config_file then
      vim.notify("Could not open file: " .. file_path, vim.log.levels.ERROR)
      return
    end

    local config_content = config_file:read("*all")
    config_file:close()

    -- Sanitize content to create safe example
    local example_content = sanitize_config(config_content)

    -- Write to example file
    local example_file = io.open(example_path, "w")
    if example_file then
      example_file:write(example_content)
      example_file:close()
      vim.notify("Synced " .. base_name .. " to " .. vim.fn.fnamemodify(example_path, ":t"), vim.log.levels.INFO)
    else
      vim.notify("Failed to open for writing: " .. example_path, vim.log.levels.ERROR)
    end
  end
end

-- Set up autocmd for automatic sync
M.setup_auto_sync = function()
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/lua/vars/*.lua",
    callback = function(ev)
      -- Skip example files
      if not ev.file:match("%.example%.lua$") then
        M.sync_file(ev.file)
      end
    end,
    desc = "Auto-sync vars/*.lua files to their *.example.lua versions",
  })
end

return M
