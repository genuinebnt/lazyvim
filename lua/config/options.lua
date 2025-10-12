-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable statusline
vim.opt.laststatus = 3  -- Global statusline
vim.opt.statusline = "" -- Clear default statusline to let lualine handle it

-- Enable tabline
vim.opt.showtabline = 2 -- Always show tabline

-- Additional UI improvements
vim.opt.cmdheight = 1
vim.opt.pumheight = 10
vim.opt.showmode = false -- Hide mode since lualine shows it
