-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Quick escape from insert mode
-- Map jk and kj to escape insert mode when pressed quickly
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode with jk" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape insert mode with kj" })

-- Tab functionality is now handled by blink.cmp configuration
-- See lua/plugins/blink-cmp.lua for completion mappings

-- Disable LazyVim's default window navigation (Ctrl+hjkl)
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")

-- Buffer navigation with Tab/Shift+Tab
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })

-- Format and save with Shift+S
vim.keymap.set("n", "<S-s>", function()
  vim.lsp.buf.format()
  vim.cmd("write")
  print("Formatted and saved")
end, { desc = "Format and save file" })

-- Panel navigation with Shift+HLJK
-- Move between explorer, editor, and terminal panels
vim.keymap.set("n", "<S-h>", function()
  vim.cmd("wincmd h")
  print("Shift+H: Moved left")
end, { desc = "Move to left panel (explorer)", noremap = true })
vim.keymap.set("n", "<S-l>", function()
  vim.cmd("wincmd l")
  print("Shift+L: Moved right")
end, { desc = "Move to right panel (editor)", noremap = true })
vim.keymap.set("n", "<S-j>", function()
  vim.cmd("wincmd j")
  print("Shift+J: Moved down")
end, { desc = "Move to panel below (terminal)", noremap = true })
vim.keymap.set("n", "<S-k>", function()
  vim.cmd("wincmd k")
  print("Shift+K: Moved up")
end, { desc = "Move to panel above (editor)", noremap = true })

-- Legacy arrow key navigation (kept for compatibility)
vim.keymap.set("n", "<S-Left>", "<C-w>h", { desc = "Move to left panel (explorer)" })
vim.keymap.set("n", "<S-Right>", "<C-w>l", { desc = "Move to right panel (editor)" })
vim.keymap.set("n", "<S-Up>", "<C-w>k", { desc = "Move to panel above" })
vim.keymap.set("n", "<S-Down>", "<C-w>j", { desc = "Move to panel below (terminal)" })

-- Alternative: More specific panel navigation for LazyVim
vim.keymap.set("n", "<leader>e", function()
  -- Toggle focus between explorer and editor
  local current_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_list_wins()

  -- Find the explorer window (neo-tree, oil, or NvimTree)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft == 'neo-tree' or ft == 'oil' or ft == 'NvimTree' then
      if current_win == win then
        -- We're in explorer, go to the first normal buffer
        vim.cmd('wincmd l')
      else
        -- We're in editor, go to explorer
        vim.api.nvim_set_current_win(win)
      end
      return
    end
  end

  -- If no explorer found, try to open netrw (built-in file explorer)
  -- or just notify user that no explorer is available
  if vim.fn.has('nvim-0.9') == 1 then
    vim.cmd('edit .')
  else
    vim.notify('No file explorer found. Consider installing neo-tree or oil.nvim', 'info')
  end
end, { desc = "Toggle focus between explorer and editor" })

-- Smart terminal navigation
vim.keymap.set("n", "<leader>t", function()
  -- Find or create terminal window
  local current_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_list_wins()

  -- Find existing terminal window
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.api.nvim_buf_get_option(buf, 'buftype')
    if bt == 'terminal' then
      if current_win == win then
        -- We're in terminal, go back to editor
        vim.cmd('wincmd k')
      else
        -- Go to terminal
        vim.api.nvim_set_current_win(win)
      end
      return
    end
  end

  -- No terminal found, open one
  vim.cmd('split | terminal')
end, { desc = "Toggle focus to/from terminal" })

-- Terminal mode mappings
vim.keymap.set("t", "<S-Up>", "<C-\\><C-n><C-w>k", { desc = "Move from terminal to panel above" })
vim.keymap.set("t", "<S-Left>", "<C-\\><C-n><C-w>h", { desc = "Move from terminal to left panel" })
vim.keymap.set("t", "<S-Right>", "<C-\\><C-n><C-w>l", { desc = "Move from terminal to right panel" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
