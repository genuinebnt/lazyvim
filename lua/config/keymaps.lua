-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", { desc = "Close current buffer", noremap = true, silent = true }) -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

vim.keymap.set({ "i", "t" }, "jk", "<Esc>")
vim.keymap.set({ "i", "t" }, "kj", "<Esc>")
vim.keymap.set({ "i", "t" }, "JK", "<Esc>")
vim.keymap.set({ "i", "t" }, "KJ", "<Esc>")

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Window navigation (Shift+H/L/J/K) — overrides LazyVim's S-h/S-l buffer defaults (use Tab instead)
vim.keymap.set("n", "<S-h>", "<C-w>h", { desc = "Go to left window", noremap = true, silent = true })
vim.keymap.set("n", "<S-l>", "<C-w>l", { desc = "Go to right window", noremap = true, silent = true })
vim.keymap.set("n", "<S-j>", "<C-w>j", { desc = "Go to lower window", noremap = true, silent = true })
vim.keymap.set("n", "<S-k>", "<C-w>k", { desc = "Go to upper window", noremap = true, silent = true })
-- Same bindings from within terminal buffers
vim.keymap.set("t", "<S-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window", noremap = true, silent = true })
vim.keymap.set("t", "<S-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window", noremap = true, silent = true })
vim.keymap.set("t", "<S-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window", noremap = true, silent = true })
vim.keymap.set("t", "<S-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window", noremap = true, silent = true })

-- --- Format and Save ---
-- We unmap default window keys first to avoid the Which-Key delay on <leader>w
local windows_keys = { "w", "d", "-", "|", "s", "v", "q" }
for _, key in ipairs(windows_keys) do
  pcall(vim.keymap.del, "n", "<leader>w" .. key)
end

-- Format + Save (now instant)
vim.keymap.set("n", "<leader>w", function()
  LazyVim.format()
  vim.cmd("w")
end, { desc = "Format and Save" })

-- Format only (no save)
vim.keymap.set("n", "<leader>F", function()
  LazyVim.format()
end, { desc = "Format Only" })

-- Move window management to <leader>W
vim.keymap.set("n", "<leader>W", "<leader>w", { desc = "Windows", remap = true })
vim.keymap.set("n", "<leader>Ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>Wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>W-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>W|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- SQL scratchpad (persisted)
vim.keymap.set("n", "<leader>sq", function()
  local path = vim.fn.stdpath("data") .. "/scratch.sql"
  vim.cmd("edit " .. path)
  vim.bo.filetype = "sql"
end, { desc = "SQL Scratchpad" })

vim.keymap.set("n", "<leader>sf", function()
  require("conform").format({ async = false })
end, { desc = "Format SQL" })

-- Claude sidebar
vim.keymap.set("n", "<leader>ac", function()
  local win = vim.g.claude_sidebar_win
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    vim.g.claude_sidebar_win = nil
    return
  end

  local buf = vim.g.claude_sidebar_buf
  vim.cmd("rightbelow vsplit")
  local sidebar_win = vim.api.nvim_get_current_win()
  vim.cmd("vertical resize 50")

  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_win_set_buf(sidebar_win, buf)
  else
    vim.cmd("terminal claude")
    vim.g.claude_sidebar_buf = vim.api.nvim_get_current_buf()
  end

  vim.g.claude_sidebar_win = sidebar_win
end, { desc = "Toggle Claude Sidebar" })
