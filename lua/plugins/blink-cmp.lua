return {
  -- Configure blink.cmp with Tab to accept, arrows for navigation
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        -- Tab accepts the current selection (normal mode Tab is for buffers)
        ["<Tab>"] = { "accept", "fallback" },
        ["<S-Tab>"] = { "accept", "fallback" },
        -- Enter also accepts
        ["<CR>"] = { "accept", "fallback" },
        -- Arrow keys for navigation
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        -- Ctrl+p/n for navigation (Vim-style)
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        -- Cancel completion
        ["<C-e>"] = { "cancel", "fallback" },
        ["<Esc>"] = { "cancel", "fallback" },
      },
    },
  },
}
