return {
  "Exafunction/windsurf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codeium").setup({
      enable_cmp_source = false,
      -- Enable/disable for specific filetypes
      filetypes = {
        bash = false,
        typescript = true,
        javascript = true,
        python = true,
        lua = true,
        rust = true,
        go = true,
        c = true,
        cpp = true,
        java = true,
        html = true,
        css = true,
        json = true,
        yaml = true,
        markdown = true,
        sh = false,
        zsh = false,
      },
      -- Disable for specific patterns
      disable_patterns = {
        "%.git/",
        "node_modules/",
        "%.venv/",
        "%.env/",
      },
    })
  end,
}
