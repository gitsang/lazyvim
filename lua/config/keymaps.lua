-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

local function keymap(modes, key, command, opts)
  for _, mode in ipairs(modes) do
    map(mode, key, command, opts)
  end
end

keymap({ "n", "x", "o" }, ";", "$", { desc = "Go to End of Line", remap = true })
keymap({ "n", "x", "o" }, "<leader>cc", "<Cmd>CodeCompanionChat<CR>", { desc = "Toggle Chat", remap = true })
keymap({ "n", "x", "o" }, "<leader>aa", "<Cmd>CodeCompanionAction<CR>", { desc = "Prompt Actions", remap = true })

if vim.o.wildoptions:match("pum") then
  vim.api.nvim_set_keymap("c", "<Up>", [[pumvisible() ? '<Left>' : '<Up>']], { expr = true })
  vim.api.nvim_set_keymap("c", "<Down>", [[pumvisible() ? '<Right>' : '<Down>']], { expr = true })
  vim.api.nvim_set_keymap("c", "<CR>", [[pumvisible() ? '<C-y>' : '<CR>']], { expr = true })
end
