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
      url = "https://api.siliconflow.cn/v1",
      api_token = require("vars.secret").siliconflow,
      model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
      --
      -- backend = "openai",
      -- url = "https://api-inference.modelscope.cn/v1",
      -- api_token = require("vars.secret").modelscope,
      -- model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
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
}
