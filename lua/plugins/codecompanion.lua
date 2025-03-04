local config = loadfile(os.getenv("HOME") .. "/.config/nvim/lua/plugins.conf/codecompanion.lua")()

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "worklink",
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
          adapter = "worklink",
        },
      },
      opts = {
        log_level = "DEBUG",
      },
      adapters = {
        worklink = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "worklink",
            env = {
              url = config.url,
              api_key = config.api_key,
              chat_url = "/v1/chat/completions",
              models_endpoint = "/v1/models",
            },
            schema = {
              model = {
                default = "gpt-4o",
              },
            },
          })
        end,
      },
    },
  },
}
