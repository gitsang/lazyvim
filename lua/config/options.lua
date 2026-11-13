-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Since Nvim 0.11 the TUI queries the host terminal for its background color
-- (OSC 11) and sets 'background' accordingly.  GNOME Terminal here answers with
-- a white background (light Adwaita theme), so Nvim would pick "light" and load
-- the tokyonight "day" variant.  Pin it to dark instead.  Setting it here also
-- marks the option as user-set, which disables Nvim's auto-detection.
vim.o.background = "dark"

vim.opt.relativenumber = false

vim.opt.autochdir = true
