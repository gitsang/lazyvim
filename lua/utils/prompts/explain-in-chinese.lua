local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "使用中文解释缓冲区代码",
  opts = {
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "explain-in-chinese",
    auto_submit = false,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[当被要求解释代码时，请遵循以下步骤：

1. 确定编程语言。
2. 描述代码的目的，并引用编程语言中的核心概念。
3. 解释每个函数或重要的代码块，包括参数和返回值。
4. 强调使用的任何特定函数或方法及其作用。
5. 如果适用，提供有关代码如何融入更大应用程序的背景。

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

        return fmt(
          [[#buffer

请解释 buffer %d 中的这段代码:

```%s
%s
```
]],
          context.bufnr,
          context.filetype,
          code
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
