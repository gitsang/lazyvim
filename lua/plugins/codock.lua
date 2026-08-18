return {
  {
    "gitsang/codock.nvim",
    opts = {
      width = 70, -- Width of the vertical split
      codock_cmd = "pi", -- Command to run in the terminal (crush, opencode, claude, gemini-cli, etc.)
      copy_to_clipboard = false, -- Copy to system clipboard
      actions = {
        {
          name = "Translate",
          description = "Translate selected words.",
          prompts = function()
            local utils = require("codock.utils")
            local selected_text = utils.get_visual_selection_text()
            local prompt = "Help me translate the following text: \n"
            prompt = prompt .. string.format("\n```\n%s\n```\n\n", selected_text)
            prompt = prompt .. "If text in English, translate it to Chinese;\n"
            prompt = prompt .. "If text in Chinese, translate it to English.\n"
            return prompt
          end,
        },
        {
          name = "Squash Commit Merge",
          description = "Merge squashed commit messages.",
          prompts = function()
            local utils = require("codock.utils")
            local current_file = utils.get_current_file()
            local prompt = "Merge commit messages: " .. current_file .. "\n"
            return prompt
          end,
        },
      },
    },
    cmd = { "Codock", "CodockFilePos", "CodockActions" },
    keys = {
      { "<leader>CCO", "<cmd>Codock opencode<cr>", desc = "Open Opencode", mode = { "n", "v" } },
      { "<leader>CCC", "<cmd>Codock claude<cr>", desc = "Open Claude", mode = { "n", "v" } },
      { "<leader>CCX", "<cmd>Codock omx --madmax --xhigh<cr>", desc = "Open Codex", mode = { "n", "v" } },
      { "<leader>CCP", "<cmd>Codock pi<cr>", desc = "Open Pi Agent", mode = { "n", "v" } },
      { "<leader>CCD", "<cmd>Codock dsh --profile tui<cr>", desc = "Open Deepseek Harness TUI", mode = { "n", "v" } },
      { "<leader>CY", ":'<,'>CodockFilePosYank<cr>", desc = "Copy file position", mode = { "n", "v" } },
      { "<leader>CP", ":'<,'>CodockFilePosPaste<cr>", desc = "Copy and paste file position", mode = { "n", "v" } },
      { "<leader>CA", ":'<,'>CodockActions<cr>", desc = "Run Codock actions", mode = { "n", "v" } },
    },
  },
}
