return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Interactive terminal: horizontal split at bottom (also set win opts so it wins over internal float default when possible).
      terminal = {
        win = {
          position = "bottom",
          height = 0.35,
          border = "rounded",
        },
        -- Terminal `t`-mode keys are set in lua/config/keymaps.lua (FileType snacks_terminal)
        -- so hide / arrows / Ctrl-hjkl always work; merged `terminal.keys` here is unreliable for `t`.
      },
      -- Configure snacks components
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        enabled = true,
        icons = {
          enabled = true,
          devicons = true,
        },
      },
      picker = {
        enabled = true,
        icons = {
          enabled = true,
          devicons = true,
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
}
