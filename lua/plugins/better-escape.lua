return {
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        timeout = vim.o.timeoutlen, -- Use vim's timeout setting
        default_mappings = true,
        mappings = {
          i = {
            j = {
              k = "<Esc>", -- jk to escape
              j = "<Esc>", -- jj to escape  
            },
            k = {
              j = "<Esc>", -- kj to escape
            },
          },
          c = {
            j = {
              k = "<C-c>",
              j = "<C-c>",
            },
          },
          t = {
            j = {
              k = "<C-\\><C-n>",
            },
          },
          v = {
            j = {
              k = "<Esc>",
            },
          },
          s = {
            j = {
              k = "<Esc>",
            },
          },
        },
      })
    end,
  },
}
