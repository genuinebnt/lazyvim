-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Quick escape from insert mode
-- Map jk and kj to escape insert mode when pressed quickly
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode with jk" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape insert mode with kj" })
