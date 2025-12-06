return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      -- Add more auto-save options if needed
      save_empty_sessions = false,
    },
    keys = {
      {
        "<leader>qr",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}