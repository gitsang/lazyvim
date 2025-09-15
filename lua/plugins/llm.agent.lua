return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "marcinjahn/gemini-cli.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    cmd = "Gemini",
    keys = {
      { "<leader>a/", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI" },
      { "<leader>aa", "<cmd>Gemini ask<cr>", desc = "Ask Gemini", mode = { "n", "v" } },
      { "<leader>af", "<cmd>Gemini add_file<cr>", desc = "Add File" },
    },
    config = true,
  },
  {
    "gitsang/qwen-code.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    cmd = "Qwen",
    keys = {
      { "<leader>qq", "<cmd>Qwen toggle<cr>", desc = "Toggle Qwen Code" },
      { "<leader>qa", "<cmd>Qwen ask<cr>", desc = "Ask Qwen", mode = { "n", "v" } },
      { "<leader>qf", "<cmd>Qwen add_file<cr>", desc = "Add File" },
    },
    config = true,
  },
  {
    "gitsang/crush.nvim",
    opts = {
      width = 60, -- Width of the vertical split
      crush_cmd = "crush --yolo", -- Command to run in the terminal
    },
    cmd = { "Crush" },
    keys = {
      { "<leader>C", "<cmd>Crush<cr>", desc = "Toggle Crush" },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      require("mcphub").setup({
        -- Required options
        port = 3000, -- Port for MCP Hub server
        config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to config file

        -- Optional options
        on_ready = function(hub)
          print("MCP Hub is serving at " .. ":" .. hub.port .. " (" .. hub.client_id .. ")")
        end,
        on_error = function(err)
          print("MCP Hub error: " .. err)
        end,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },
}
