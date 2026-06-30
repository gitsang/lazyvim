return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>cc", mode = { "n", "v" }, false },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      diagnostics = {
        -- for virtual text at end of line
        virtual_text = {
          source = true,
        },
        -- for the floating diagnostics window when press `<leader>cd`
        float = {
          source = true,
        },
      },
    },
  },
  {
    "nvim-lua/plenary.nvim",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          vim.keymap.set("n", "%", function()
            local line = vim.fn.getline(".")
            if line:match("^```") then
              vim.fn.search("^```", "bW")
            else
              print("Not on a Markdown code block delimiter")
            end
          end, { buffer = args.buf, noremap = true, silent = true, desc = "Jump to markdown code fence pair" })
        end,
      })
    end,
  },
  {
    "majutsushi/tagbar",
  },
}
