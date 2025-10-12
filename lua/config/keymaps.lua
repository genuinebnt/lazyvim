-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Quick escape from insert mode
-- Map jk and kj to escape insert mode when pressed quickly
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode with jk" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape insert mode with kj" })

-- Tab functionality
-- Defer Tab mappings until after plugin setup to avoid DAP conflicts
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    -- Tab for autocompletion in insert mode
    vim.keymap.set("i", "<Tab>", function()
      -- Check if blink.cmp is available (LazyVim's new default)
      local blink_ok, blink = pcall(require, "blink.cmp")
      if blink_ok then
        local visible_ok, is_visible = pcall(blink.is_visible)
        if visible_ok and is_visible then
          local select_ok = pcall(blink.select_next)
          if select_ok then return end
        end
      end
      
      -- Fallback to nvim-cmp if available
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        local visible_ok, is_visible = pcall(cmp.visible)
        if visible_ok and is_visible then
          pcall(cmp.select_next_item)
          return
        end
      end
      
      -- Default tab behavior
      return "<Tab>"
    end, { expr = true, silent = true, desc = "Next completion item or tab" })

    -- Shift+Tab for previous completion item
    vim.keymap.set("i", "<S-Tab>", function()
      -- Check if blink.cmp is available (LazyVim's new default)
      local blink_ok, blink = pcall(require, "blink.cmp")
      if blink_ok then
        local visible_ok, is_visible = pcall(blink.is_visible)
        if visible_ok and is_visible then
          local select_ok = pcall(blink.select_prev)
          if select_ok then return end
        end
      end
      
      -- Fallback to nvim-cmp if available
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        local visible_ok, is_visible = pcall(cmp.visible)
        if visible_ok and is_visible then
          pcall(cmp.select_prev_item)
          return
        end
      end
      
      -- Default shift-tab behavior
      return "<S-Tab>"
    end, { expr = true, silent = true, desc = "Previous completion item or shift-tab" })
  end,
})

-- Buffer navigation in normal mode
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
