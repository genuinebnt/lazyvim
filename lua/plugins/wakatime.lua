return {
  {
    "wakatime/vim-wakatime",
    lazy = false, -- Load immediately to track all activity
    config = function()
      -- WakaTime will prompt for API key on first run
      -- You can also set it manually:
      -- vim.g.wakatime_api_key = "your-api-key-here"
      
      -- Optional: Set custom settings
      -- vim.g.wakatime_cli_location = "/usr/local/bin/wakatime-cli"
      
      -- Show WakaTime status in command line (optional)
      vim.g.wakatime_screensaver_timeout = 300 -- 5 minutes
    end,
  },
}