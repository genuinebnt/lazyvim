return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false, -- Load early so other plugins can use it
    priority = 1000, -- High priority to load first
    config = function()
      local ok, devicons = pcall(require, "nvim-web-devicons")
      if not ok then
        return
      end

      -- Configure devicons
      devicons.setup({
        -- Override default icons for specific filetypes
        override = {
          -- Add custom icons for specific file types
          ["lua"] = {
            icon = "",
            color = "#51a0cf",
            name = "lua",
          },
          ["py"] = {
            icon = "🐍",
            color = "#3776ab",
            name = "python",
          },
          ["js"] = {
            icon = "",
            color = "#f7df1e",
            name = "javascript",
          },
          ["ts"] = {
            icon = "󰛦",
            color = "#3178c6",
            name = "typescript",
          },
          ["rs"] = {
            icon = "🦀",
            color = "#dea584",
            name = "rust",
          },
          ["go"] = {
            icon = "󰟓",
            color = "#00add8",
            name = "go",
          },
          ["md"] = {
            icon = "󰉋",
            color = "#ffffff",
            name = "markdown",
          },
          ["json"] = {
            icon = "󰘋",
            color = "#f9d71c",
            name = "json",
          },
          ["yaml"] = {
            icon = "󰰳",
            color = "#cb171e",
            name = "yaml",
          },
          ["toml"] = {
            icon = "󰰳",
            color = "#9c4221",
            name = "toml",
          },
          ["dockerfile"] = {
            icon = "󰡨",
            color = "#2496ed",
            name = "dockerfile",
          },
          ["gitignore"] = {
            icon = "󰊢",
            color = "#f14c28",
            name = "gitignore",
          },
          ["vim"] = {
            icon = "󰀚",
            color = "#019833",
            name = "vim",
          },
          ["neovim"] = {
            icon = "󰀚",
            color = "#57a143",
            name = "neovim",
          },
        },
        -- Enable default icons for all filetypes
        default = true,
      })
    end,
  },
}
