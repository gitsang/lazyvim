return {
  {
    "ggml-org/llama.vim",
    enabled = false,
    init = function()
      vim.g.llama_config = {
        endpoint = "http://10.60.20.7:1234/v1/chat/completions",
        auto_fim = true,
      }
    end,
  },
  {
    "huggingface/llm.nvim",
    enabled = true,
    opts = {
      -- backend = "openai",
      -- url = "http://10.60.20.7:1234/v1",
      -- model = "qwen/qwen3-30b-a3b-2507",
      --
      -- backend = "ollama",
      -- url = "http://10.60.20.7:1234/v1",
      -- model = "qwen2.5-coder:7b",
      --
      backend = "openai",
      -- url = "https://api.siliconflow.cn/v1",
      url = "http://openai-proxy.ops.yl.c8g.top:8888/siliconflow/v1",
      api_token = require("vars.secret").siliconflow,
      model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
      --
      -- backend = "openai",
      -- url = "https://api-inference.modelscope.cn/v1",
      -- url = "http://openai-proxy.ops.yl.c8g.top:8888/modelscope/v1",
      -- api_token = require("vars.secret").modelscope,
      -- model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
      --
      tokens_to_clear = { "<|endoftext|>" },
      fim = {
        enabled = true,
        prefix = "<|fim_prefix|>",
        middle = "<|fim_middle|>",
        suffix = "<|fim_suffix|>",
      },
      request_body = {
        suffix = "\n",
        options = {
          temperature = 0.7,
          top_p = 0.8,
          top_k = 20,
          repetition_penalty = 1.05,
          -- temperature = 0.01,
          -- top_p = 0.2,
          -- num_predict = 4096,
          -- num_ctx = 8192,
          -- num_predict = 4096,
          -- num_ctx = 8192,
          stop = {
            "<|endoftext|>",
            "<|fim_prefix|>",
            "<|fim_middle|>",
            "<|fim_suffix|>",
            "<|fim_pad|>",
            "<|repo_name|>",
            "<|file_sep|>",
            "<|im_start|>",
            "<|im_end|>",
            "/src/",
            "#- coding: utf-8",
            "```",
          },
        },
        keep_alive = 1800,
      },
      debounce_ms = 150,
      accept_keymap = "<C-g>",
      dismiss_keymap = "<S-Tab>",
      tls_skip_verify_insecure = false,
      lsp = {
        bin_path = "/home/debian/.local/src/llm-ls/target/release/llm-ls",
        host = nil,
        port = nil,
        cmd_env = {
          -- ~/.cache/llm_ls/llm-ls.log
          LLM_LOG_LEVEL = "DEBUG",
        },
        version = "0.5.3",
      },
      tokenizer = nil,
      context_window = 8192,
      enable_suggestions_on_startup = true,
      enable_suggestions_on_files = "*",
      disable_url_path_completion = false,
    },
  },
  {
    "Exafunction/codeium.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      enable_cmp_source = true,
      virtual_text = {
        enabled = true,
        key_bindings = {
          accept = "<C-g>",
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 100,
      })
    end,
  },
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
