return {
  -- Blink.cmp: Tab cycles suggestions, Enter accepts (↑/↓/C-n/C-p still work from default preset)
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      -- Tab / Shift-Tab: move through completion items; Enter: accept.
      -- (Normal-mode Tab/S-Tab for buffers are separate maps in config/keymaps.lua.)
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
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
