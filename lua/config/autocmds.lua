-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ponytail: LazyVim assume vim.hl.hl_op exists on nvim>=0.13, but our dev build only has on_yank. Replace its autocmd with the stdlib call that actually exists.
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_highlight_yank")
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("lazyvim_highlight_yank", { clear = true }),
  callback = function()
    (vim.hl and vim.hl.on_yank or vim.highlight.on_yank)()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.spelllang = "en_us,cjk"
  end,
})

vim.cmd("packadd nvim.difftool")
