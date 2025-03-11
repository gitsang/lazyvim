return {
  {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      "MeanderingProgrammer/render-markdown.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      opts = {
        -- ~/.local/state/nvim/codecompanion.log
        log_level = "TRACE",
        language = "中文",
        system_prompt = require("utils.prompts.system-prompt"),
      },
      strategies = {
        chat = {
          adapter = require("vars.environment").codecompanion.chat.adapter,
          keymaps = {
            send = {
              modes = { n = "<C-s>", i = "<C-s>" },
            },
            close = {
              modes = { n = "<C-c>", i = "<C-c>" },
            },
          },
          slash_commands = {
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
          },
        },
        inline = {
          adapter = require("vars.environment").codecompanion.inline.adapter,
        },
      },
      adapters = require("vars.codecompanion-adapter"),
      prompt_library = {
        ["Explain in Chinese"] = require("utils.prompts.explain-in-chinese"),
        ["Fix in Chinese"] = require("utils.prompts.fix-in-chinese"),
      },
      display = {
        chat = {
          intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
          show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          separator = "─", -- The separator between the different messages in the chat buffer
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = false, -- Open the chat buffer in insert mode?
        },
        diff = {
          enabled = true,
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "default", -- default|mini_diff
        },
      },
    },
  },
}
