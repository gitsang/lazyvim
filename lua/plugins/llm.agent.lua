---@see require('codecompanion')

return {
  {
    "gitsang/crush.nvim",
    opts = {
      width = 80, -- Width of the vertical split
      fixed_width = true, -- Whether to fix the width (true = locked, false = adjustable)
      crush_cmd = "opencode", -- Command to run in the terminal
      copy_to_clipboard = true, -- Copy to system clipboard
      actions = {},
    },
    cmd = { "Crush", "CrushFilePos", "CrushActions" },
    keys = {
      { "<leader>CC", "<cmd>Crush<cr>", desc = "Toggle Crush", mode = { "n" } },
      { "<leader>CP", ":'<,'>CrushFilePos<cr>", desc = "Copy file path and line info", mode = { "n", "v" } },
      { "<leader>CA", ":'<,'>CrushActions<cr>", desc = "Run Crush actions", mode = { "n", "v" } },
    },
  },
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
      "folke/noice.nvim",
    },
    keys = {
      {
        "<leader>cc",
        "<Cmd>CodeCompanionAction<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Actions",
      },
    },
    opts = {
      opts = {
        -- ~/.local/state/nvim/codecompanion.log
        log_level = "TRACE",
        language = require("vars.config").codecompanion.language,
        -- system_prompt = require("plugins.codecompanion.system_prompt"),
      },
      strategies = {
        chat = {
          adapter = require("vars.config").codecompanion.chat.adapter,
          variables = require("plugins.codecompanion.variables"),
          keymaps = {
            send = {
              modes = { n = "<CR>", i = "<C-s>" },
            },
            close = {
              modes = { n = "<C-q>", i = "<C-q>" },
            },
          },
          slash_commands = require("plugins.codecompanion.slash_commands"),
          roles = {
            llm = function(adapter)
              return "CodeCompanion (" .. adapter.schema.model.default .. "@" .. adapter.name .. ")"
            end,
            ---The header name for your messages
            ---@type string
            user = "User",
          },
        },
        inline = {
          adapter = require("vars.config").codecompanion.inline.adapter,
        },
        cmd = {
          adapter = require("vars.config").codecompanion.cmd.adapter,
        },
      },
      adapters = require("plugins.codecompanion.adapter"),
      prompt_library = require("plugins.codecompanion.prompt_library"),
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
        chat = {
          -- Change the default icons
          intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
          show_header_separator = true, -- Show header separators in the chat buffer?
          separator = "─", -- The separator between the different messages in the chat buffer
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = false, -- Open the chat buffer in insert mode?
          icons = {
            pinned_buffer = " ",
            watched_buffer = "👀 ",
          },
          -- Alter the sizing of the debug window
          debug_window = {
            ---@return number|fun(): number
            width = vim.o.columns - 5,
            ---@return number|fun(): number
            height = vim.o.lines - 2,
          },
          -- Options to customize the UI of the chat buffer
          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
            position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
            border = "single",
            height = 0.8,
            width = 0.35,
            relative = "editor",
            full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },
          token_count = function(tokens)
            return " (" .. tokens .. " tokens)"
          end,
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
    init = function()
      require("plugins.codecompanion.plugins.notification").init()
      require("plugins.codecompanion.plugins.autosave")
    end,
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>claude", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    },
  },
}
