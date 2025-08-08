local default_stop = {
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
}

return {
  {
    "ggml-org/llama.vim",
    enabled = true,
    init = function()
      -- docker run --name llama.cpp -v ./cache:/root/.cache/llama.cpp -p 8012:8012 -d ghcr.io/ggml-org/llama.cpp:server --fim-qwen-1.5b-default
      vim.g.llama_config = {
        endpoint = "http://127.0.0.1:8012/infill",
        keymap_accept_full = "<C-g>",
        keymap_accept_line = "<C-l>",
        keymap_accept_word = "<C-b>",
      }
    end,
  },
  {
    "huggingface/llm.nvim",
    enabled = false,
    opts = {
      -- https://api.siliconflow.cn/v1
      backend = "openai",
      url = "http://openai-proxy.ops.yl.c8g.top:8888/siliconflow/v1",
      api_token = require("vars.secret").siliconflow,
      model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
      tokens_to_clear = { "<|endoftext|>" },
      fim = {
        enabled = true,
        prefix = "<|fim_prefix|>",
        middle = "<|fim_middle|>",
        suffix = "<|fim_suffix|>",
      },
      request_body = {
        temperature = 0.7,
        top_p = 0.8,
        truncation = "auto",
        stop = default_stop,
      },

      -- lmstudio
      -- backend = "openai",
      -- url = "http://10.60.20.7:1234",
      -- api_token = "-",
      -- model = "qwen/qwen3-coder-30b",
      -- tokens_to_clear = { "<|endoftext|>" },
      -- fim = {
      --   enabled = true,
      --   prefix = "<|fim_prefix|>",
      --   middle = "<|fim_middle|>",
      --   suffix = "<|fim_suffix|>",
      -- },
      -- request_body = {
      --   temperature = 0.7,
      --   top_p = 0.8,
      --   truncation = "auto",
      -- },

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
