local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "修复选中代码",
  opts = {
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "fix-in-chinese",
    auto_submit = false,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[当被要求修复代码时，请按照以下步骤操作：

1. **识别问题**：仔细阅读提供的代码，找出任何潜在的问题或改进之处。
2. **计划修复**：用伪代码描述修复代码的计划，详细说明每一步。
3. **实施修复**：在一个单独的代码块中编写更正后的代码。
4. **解释修复**：简要解释所做的更改及其原因。

确保已修复的代码：

- 包含必要的导入。
 - 能够处理潜在错误0
- 遵循可读性和可维护性的最佳实践。
- 格式正确。

另外你必须：

- 使用Markdown格式，并在代码块开头注明编程语言名称。
- 所有非编码响应都必须以中文形式呈现
]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        local diagnostics = vim.diagnostic.get(context.bufnr, { lnum = context.start_line - 1 })

        local diagnostic_messages = {}
        for _, diagnostic in ipairs(diagnostics) do
          table.insert(diagnostic_messages, diagnostic.message)
        end

        return fmt(
          [[@editor #buffer

请修复 buffer %d 中的代码，并解释修复方式:

```%s
%s
```

诊断信息：

```
%s
```
]],
          context.bufnr,
          context.filetype,
          code,
          table.concat(diagnostic_messages, "\n")
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
