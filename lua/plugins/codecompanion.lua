local secret = loadfile(os.getenv("HOME") .. "/.config/nvim/lua/vars/secret.lua")()

return {
  {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      { -- Optional: For prettier markdown rendering
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "codecompanion" },
      },
      { -- Optional: Improves `vim.ui.select`
        "stevearc/dressing.nvim",
        opts = {},
      },
    },
    opts = {
      opts = {
        log_level = "TRACE",
        language = "中文",
        system_prompt = require("utils.prompts.system-prompt"),
      },
      strategies = {
        chat = {
          adapter = "worklink_deepseek",
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
          },
        },
        inline = {
          adapter = "worklink_deepseek",
        },
      },
      adapters = {
        worklink_deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            url = "https://worklink.yealink.com/llmproxy/v1/chat/completions",
            env = {
              api_key = secret.worklink_llm,
            },
            schema = {
              model = {
                default = "deepseek-v3",
                choices = {
                  ["deepseek-r1"] = { opts = { can_reason = true } },
                  "deepseek-v3",
                },
              },
            },
          })
        end,
        worklink_openai = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            url = "https://worklink.yealink.com/llmproxy/v1/chat/completions",
            env = {
              api_key = secret.worklink_llm,
            },
            schema = {
              model = {
                default = "gpt-4o",
                choices = {
                  "gpt-4o",
                  "gpt-4o-mini",
                },
              },
            },
          })
        end,
        local_ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://10.5.204.206:11434",
            },
            schema = {
              model = {
                default = "qwen2.5-coder:7b",
              },
            },
          })
        end,
      },
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
