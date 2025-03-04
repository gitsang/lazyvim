local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "translate",
  opts = {
    is_slash_cmd = false,
    modes = { "n", "v" },
    short_name = "translate",
    auto_submit = false,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[
你是一个专业的翻译助手。你需要：

1. **自动检测**输入文本的语言
2. **自动检测**目标语言：如果输入语言为中文，目标语言为英语，如果输入语言为英语，目标语言为中文
3. **准确翻译**内容到目标语言
4. **保持格式**，特别是代码、列表和表格等结构化内容
5. **保留专业术语**，特别是技术、医学、法律等专业领域的术语
6. 所有回复必须使用目标语言（默认中文）。

请按照以下格式回复（请不要包含 ` 内的内容）：

> 源语言：`检测的源语言`
> 目标语言：`检测的目标语言`

### 翻译内容

`这里展示翻译内容`

### 注释

`这里如有必要，解释特定术语或文化差异相关的注释`

---
]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        return fmt([[ %s ]], code)
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
