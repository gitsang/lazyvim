local M = {}

-- Function to align YAML values at a specified column
local function align_yaml_values(column)
  -- Validate column parameter
  if not column or type(column) ~= "number" or column < 1 then
    print("YamlAlignValue: Please provide a valid column number (greater than 0)")
    return
  end

  -- Save current cursor position
  local view = vim.fn.winsaveview()

  -- Pattern to match key-value pairs in YAML (key: value)
  -- This will match lines with format: key: value or key:value
  local pattern = "^(%s*)([^:#%s][^:]*):(%s*)(.*)$"

  -- Get all lines in the buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Process each line
  local new_lines = {}
  for _, line in ipairs(lines) do
    local indent, key, sep_space, value = line:match(pattern)
    if key and value and value ~= "" then
      -- Calculate how many spaces we need to align the value at the specified column
      local key_part_length = #indent + #key + 1 + #sep_space
      local spaces_needed = math.max(0, column - key_part_length)
      local new_line = indent .. key .. ":" .. string.rep(" ", spaces_needed) .. value
      table.insert(new_lines, new_line)
    else
      -- Keep lines that don't match the pattern unchanged
      table.insert(new_lines, line)
    end
  end

  -- Replace all lines in the buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)

  -- Restore cursor position
  vim.fn.winrestview(view)

  print("YAML values aligned at column " .. column)
end

function M.setup()
  vim.api.nvim_create_user_command("YamlAlignValue", function(opts)
    local column = tonumber(opts.args)
    if not column then
      print("YamlAlignValue: Please provide a column number")
      return
    end
    align_yaml_values(column)
  end, {
    desc = "Align YAML values at specified column",
    nargs = 1,
  })
end

return M

