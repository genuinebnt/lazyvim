return {
  -- Supermaven backend. Inline ghost text + native keymaps disabled so
  -- suggestions flow through blink-cmp's menu alongside LSP.
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    dependencies = { "Huijiro/blink-cmp-supermaven" },
    opts = {
      disable_inline_completion = true,
      disable_keymaps = true,
      log_level = "off",
    },
    config = function(_, opts)
      require("supermaven-nvim").setup(opts)
      -- Start disabled so AI doesn't interfere with thinking / syntax learning.
      -- Flip on with <leader>as when writing boilerplate.
      pcall(vim.cmd, "SupermavenStop")
    end,
    keys = {
      {
        "<leader>as",
        "<cmd>SupermavenToggle<cr>",
        mode = "n",
        desc = "Toggle Supermaven (AI suggestions)",
      },
    },
  },

  -- Disable Copilot's ghost text — suggestions flow through blink-cmp instead.
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  -- Register both AI sources in blink-cmp. blink-cmp.lua already has
  -- `opts_extend = { "sources.default" }` so these get appended, not replaced.
  {
    "saghen/blink.cmp",
    dependencies = {
      "Huijiro/blink-cmp-supermaven",
      "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      sources = {
        default = { "supermaven", "copilot" },
        providers = {
          supermaven = {
            name = "supermaven",
            module = "blink-cmp-supermaven",
            async = true,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            async = true,
          },
        },
      },
    },
  },
}
