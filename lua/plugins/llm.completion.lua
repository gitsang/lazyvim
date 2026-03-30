return {
  {
    "ggml-org/llama.vim",
    enabled = true,
    init = function()
      vim.g.llama_config = {
        endpoint = require("vars.config").llama.endpoint,
        keymap_fim_accept_full = "<C-g>",
        keymap_fim_accept_line = "<C-l>",
        keymap_fim_accept_word = "<C-b>",
      }
    end,
  },
}
