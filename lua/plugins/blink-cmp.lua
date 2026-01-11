return {
  -- Configure blink.cmp with Tab to accept, arrows for navigation
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
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
      
      appearance = {
        nerd_font_variant = "mono",
      },

      -- Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      
      -- Rust fuzzy matcher for better performance
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
}
