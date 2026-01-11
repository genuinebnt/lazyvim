-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Custom keymap categories:
-- 1. Panel navigation (Shift+HJKL)
-- 2. Window resizing (Arrow keys + Ctrl+Arrow)
-- 3. Buffer navigation (Tab/Shift+Tab)
-- 4. Format and save (<leader>w)
-- 5. Window operations (<leader>W + key)

-- Quick escape from insert mode is now handled by better-escape.nvim
-- Supports jk, kj, and jj mappings with better timing and behavior

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

-- Format and save with <leader>w (overriding LazyVim's window menu)
vim.keymap.set("n", "<leader>w", function()
  vim.lsp.buf.format()
  vim.cmd("write")
end, { desc = "Format and save file" })

-- Window menu moved to <leader>W (capital W for windows)
vim.keymap.set("n", "<leader>Ww", "<C-w>w", { desc = "Window: Switch windows" })
vim.keymap.set("n", "<leader>Wd", "<C-w>c", { desc = "Window: Delete window" })
vim.keymap.set("n", "<leader>W-", "<C-w>s", { desc = "Window: Split window below" })
vim.keymap.set("n", "<leader>W|", "<C-w>v", { desc = "Window: Split window right" })
vim.keymap.set("n", "<leader>W=", "<C-w>=", { desc = "Window: Resize equal" })
vim.keymap.set("n", "<leader>Wm", "<C-w>_<C-w>|", { desc = "Window: Maximize" })
vim.keymap.set("n", "<leader>Wo", "<C-w>o", { desc = "Window: Close other windows" })

-- Panel navigation with Shift+HLJK
-- Move between explorer and editor panels (terminal is now floating)
vim.keymap.set("n", "<S-h>", function()
  vim.cmd("wincmd h")
end, { desc = "Panel: Move left (explorer)", noremap = true })
vim.keymap.set("n", "<S-l>", function()
  vim.cmd("wincmd l")
end, { desc = "Panel: Move right (editor)", noremap = true })
vim.keymap.set("n", "<S-j>", function()
  vim.cmd("wincmd j")
end, { desc = "Panel: Move down", noremap = true })
vim.keymap.set("n", "<S-k>", function()
  vim.cmd("wincmd k")
end, { desc = "Panel: Move up", noremap = true })

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

-- Terminal navigation is now handled by floaterm plugin

-- Terminal mode mappings
vim.keymap.set("t", "<S-Up>", "<C-\\><C-n><C-w>k", { desc = "Move from terminal to panel above" })
vim.keymap.set("t", "<S-Left>", "<C-\\><C-n><C-w>h", { desc = "Move from terminal to left panel" })
vim.keymap.set("t", "<S-Right>", "<C-\\><C-n><C-w>l", { desc = "Move from terminal to right panel" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Windsurf AI code completion keybindings (integrated with blink.cmp)
vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true, desc = "Accept Windsurf suggestion" })
vim.keymap.set("i", "<C-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true, desc = "Cycle Windsurf suggestions forward" })
vim.keymap.set("i", "<C-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true, desc = "Cycle Windsurf suggestions backward" })
vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true, desc = "Clear Windsurf suggestions" })

-- Window resizing with arrow keys
vim.keymap.set("n", "<Up>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("wincmd +")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Resize: Increase height", noremap = true, silent = false })

vim.keymap.set("n", "<Down>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("wincmd -")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Decrease window height", noremap = true, silent = false })

vim.keymap.set("n", "<Left>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("wincmd <")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Decrease window width", noremap = true, silent = false })

vim.keymap.set("n", "<Right>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("wincmd >")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Increase window width", noremap = true, silent = false })

-- Alternative window resizing with Ctrl+Arrow keys (for more precise control)
vim.keymap.set("n", "<C-Up>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("5wincmd +")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Increase window height by 5 lines", noremap = true, silent = false })

vim.keymap.set("n", "<C-Down>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("5wincmd -")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Decrease window height by 5 lines", noremap = true, silent = false })

vim.keymap.set("n", "<C-Left>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("5wincmd <")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Decrease window width by 5 columns", noremap = true, silent = false })

vim.keymap.set("n", "<C-Right>", function()
  local current_win = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_win), 'buftype')
  if buftype == "" then
    vim.cmd("5wincmd >")
  else
    print("Cannot resize this buffer type:", buftype)
  end
end, { desc = "Increase window width by 5 columns", noremap = true, silent = false })

-- Debug function to check window and buffer information
vim.keymap.set("n", "<leader>wd", function()
  local wins = vim.api.nvim_list_wins()
  for i, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    local name = vim.api.nvim_buf_get_name(buf)
    print(string.format("Window %d: buftype='%s', filetype='%s', name='%s'", i, buftype, filetype, name))
  end
end, { desc = "Debug window information", noremap = true })

-- Devicons utility functions
vim.keymap.set("n", "<leader>di", function()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand("%:t")
    local icon, color = devicons.get_icon(filename, filetype)
    if icon then
      print(string.format("File: %s | Icon: %s | Color: %s | Type: %s", filename, icon, color, filetype))
    else
      print(string.format("File: %s | No icon found | Type: %s", filename, filetype))
    end
  else
    print("Devicons not available")
  end
end, { desc = "Show file icon info", noremap = true })

-- Undotree keybindings
vim.keymap.set("n", "<leader>u", function()
  vim.cmd("UndotreeToggle")
end, { desc = "Undo: Toggle undotree", noremap = true })

vim.keymap.set("n", "<leader>U", function()
  vim.cmd("UndotreeFocus")
end, { desc = "Undo: Focus undotree", noremap = true })

-- Additional undo/redo keybindings for better workflow
vim.keymap.set("n", "<C-r>", function()
  vim.cmd("redo")
end, { desc = "Redo last change", noremap = true })

vim.keymap.set("n", "<leader>ur", function()
  vim.cmd("UndotreeRefresh")
end, { desc = "Undo: Refresh undotree", noremap = true })

-- Snacks explorer keybindings
vim.keymap.set("n", "<leader>e", function()
  require("snacks").explorer.open()
end, { desc = "Explorer: Open snacks explorer", noremap = true })

vim.keymap.set("n", "<leader>E", function()
  require("snacks").picker.open()
end, { desc = "Explorer: Open snacks picker", noremap = true })

-- Test snacks icons
vim.keymap.set("n", "<leader>et", function()
  local ok, snacks = pcall(require, "snacks")
  if ok then
    print("Snacks loaded successfully")
    local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
    if devicons_ok then
      print("Devicons loaded successfully")
      local filename = vim.fn.expand("%:t")
      local filetype = vim.bo.filetype
      local icon, color = devicons.get_icon(filename, filetype)
      print(string.format("File: %s | Icon: %s | Color: %s", filename, icon or "none", color or "none"))
    else
      print("Devicons not loaded")
    end
  else
    print("Snacks not loaded")
  end
end, { desc = "Test: Check snacks and devicons", noremap = true })
