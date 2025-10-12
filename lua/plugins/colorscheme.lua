return {
  -- Configure LazyVim to use tokyonight with transparency
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      -- Enable transparent background
      transparent = true,
      -- Style options
      style = "night", -- Can be "storm", "moon", "night", or "day"
      -- Additional transparency settings
      styles = {
        -- Background styles for different elements
        sidebars = "transparent", -- style for sidebars
        floats = "transparent", -- style for floating windows
      },
    },
  },

  -- Configure LazyVim to load tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- Alternative: If you want to use a different transparent colorscheme
  -- Uncomment one of the following blocks and comment out the tokyonight config above

  -- Catppuccin with transparency
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   opts = {
  --     -- Enable transparent background
  --     transparent_background = true,
  --     -- Flavor options: "latte", "frappe", "macchiato", "mocha"
  --     flavour = "mocha", -- Default to mocha for dark theme
  --     -- Additional transparency settings
  --     styles = {
  --       -- Background styles for different elements
  --       sidebars = "transparent", -- style for sidebars
  --       floats = "transparent", -- style for floating windows
  --     },
  --   },
  -- },

  -- Gruvbox with transparency
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   opts = {
  --     transparent_mode = true,
  --   },
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "gruvbox",
  --   },
  -- },
}