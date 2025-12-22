return {
  {
    "ggml-org/llama.vim",
    enabled = true,
    init = function()
      -- # ========== Run Qwen2.5 Coder ========== #
      -- docker run -d \
      --    --name llama-server \
      --    -v ./cache:/root/.cache/llama.cpp \
      --    -p 8012:8012 \
      --    ghcr.io/ggml-org/llama.cpp:server \
      --      -hf ggml-org/Qwen2.5-Coder-0.5B-Q8_0-GGUF \
      --      --port 8012
      --
      -- # ========== Run Qwen3 Coder ========== #
      -- docker run -d \
      --    --name llama-server \
      --    -v ./cache:/root/.cache/llama.cpp \
      --    -p 8012:8012 \
      --    ghcr.io/ggml-org/llama.cpp:server \
      --      -hf unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:TQ1_0 \
      --      --port 8012
      vim.g.llama_config = {
        endpoint = require("vars.config").llama.endpoint,
        keymap_accept_full = "<C-g>",
        keymap_accept_line = "<C-l>",
        keymap_accept_word = "<C-b>",
      }
    end,
  },
}
