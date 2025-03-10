-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map("n", ";", "$", { desc = "Go to End of Line", remap = true })
map("x", ";", "$", { desc = "Go to End of Line", remap = true })
map("o", ";", "$", { desc = "Go to End of Line", remap = true })
