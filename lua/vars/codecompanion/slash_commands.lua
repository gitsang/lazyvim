-- 为了向后兼容，将引用重定向到新的模块化结构
return {
  ["file"] = require("vars.codecompanion.slash_commands.file"),
  ["git_files"] = require("vars.codecompanion.slash_commands.git_files"),
  ["diagnostics"] = require("vars.codecompanion.slash_commands.diagnostics"),
  ["web_search"] = require("vars.codecompanion.slash_commands.web_search"),
}
