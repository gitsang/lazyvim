local secret = loadfile(os.getenv("HOME") .. "/.config/nvim/lua/vars/secret.lua")()

return {
  {
    "huggingface/llm.nvim",
    enabled = true,
    opts = {
      backend = "ollama",
      url = "http://10.5.204.206:11434",
      model = "qwen2.5-coder:7b",
      -- backend = "openai",
      -- url = "https://api.siliconflow.cn/v1",
      -- api_token = secret.siliconflow,
      -- model = "Qwen/Qwen2.5-Coder-7B-Instruct",
      tokens_to_clear = { "<|endoftext|>" },
      fim = {
        enabled = false,
        prefix = "<|fim_prefix|>",
        middle = "<|fim_middle|>",
        suffix = "<|fim_suffix|>",
      },
      request_body = {
        suffix = "\n",
        options = {
          temperature = 0.01,
          top_p = 0.2,
          num_predict = 4096,
          num_ctx = 8192,
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
      accept_keymap = "<Tab>",
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
}
