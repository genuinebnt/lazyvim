-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here

local buffer_util = require("config.buffer_util")
local is_work_buffer = buffer_util.is_work_buffer

local function any_work_buffer_left()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_work_buffer(buf) then
      return true
    end
  end
  return false
end

-- BufDelete only (BufWipeout often pairs with it and would duplicate the prompt).
vim.api.nvim_create_autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("QuitWhenOnlyExplorerOrTerminal", { clear = true }),
  callback = function()
    vim.schedule(function()
      if not any_work_buffer_left() then
        vim.cmd("confirm qa")
      end
    end)
  end,
})
