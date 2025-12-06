return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Ensure SQL files use sqlfluff
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.sql = { "sqlfluff" }
      
      -- Make sure sqlfluff is configured properly
      opts.formatters = opts.formatters or {}
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=postgres", "-" },
      }
    end,
  },
}