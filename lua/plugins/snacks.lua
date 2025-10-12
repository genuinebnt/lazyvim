return {
  {
    "snacks.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Configure snacks explorer
      explorer = {
        -- Configure icons properly
        icons = {
          enabled = true,
          devicons = true,
        },
      },
      -- Configure snacks picker
      picker = {
        -- Configure icons properly
        icons = {
          enabled = true,
          devicons = true,
        },
      },
    },
    config = function(_, opts)
      local ok, snacks = pcall(require, "snacks")
      if not ok then
        return
      end
      
      -- Setup snacks with options
      snacks.setup(opts)
      
      -- Ensure devicons is loaded
      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
      if devicons_ok then
        -- Force devicons setup
        devicons.setup()
      end
    end,
  },
}
