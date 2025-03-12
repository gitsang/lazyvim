return {
  ["file"] = {
    callback = "strategies.chat.slash_commands.file",
    description = "Select a file using Telescope",
    opts = {
      provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
      contains_code = true,
    },
  },
  ["git_files"] = {
    description = "List git files",
    ---@class CodeCompanion.Chat
    ---@field add_reference fun(self: CodeCompanion.Chat, opts: table, type: string, tag: string): nil
    ---@param chat CodeCompanion.Chat
    callback = function(chat)
      local handle = io.popen("git ls-files")
      if handle ~= nil then
        local result = handle:read("*a")
        handle:close()
        chat:add_reference({ content = result }, "git", "<git_files>")
      else
        return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
      end
    end,
    opts = {
      contains_code = false,
    },
  },
  ["diagnostics"] = {
    description = "Show diagnostics messages",
    ---@param chat CodeCompanion.Chat
    callback = function(chat)
      local cursor_pos = vim.api.nvim_win_get_cursor(0) -- 获取当前光标位置 (行号, 列号)
      local line_num = cursor_pos[1] - 1 -- 转换为 0-based 行号
      local diagnostics = vim.diagnostic.get(0) -- 获取当前缓冲区的诊断信息

      -- 过滤出与光标所在行相关的诊断信息
      local line_diagnostics = {}
      for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.lnum == line_num then
          table.insert(
            line_diagnostics,
            string.format("Line %d: %s: %s", diagnostic.lnum + 1, diagnostic.severity, diagnostic.message)
          )
        end
      end

      if #line_diagnostics > 0 then
        chat:add_reference({ content = table.concat(line_diagnostics, "\n") }, "diagnostics", "<diagnostics>")
      else
        return vim.notify(
          string.format("No diagnostics available for line %d", line_num),
          vim.log.levels.INFO,
          { title = "CodeCompanion" }
        )
      end
    end,
    opts = {
      contains_code = true,
    },
  },
}
