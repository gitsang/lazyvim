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
        system_prompt = require("vars.codecompanion.system_prompt"),
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
          slash_commands = require("vars.codecompanion.slash_commands"),
        },
        inline = {
          adapter = require("vars.environment").codecompanion.inline.adapter,
        },
      },
      adapters = require("vars.codecompanion.adapter"),
      prompt_library = require("vars.codecompanion.prompt_library"),
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
