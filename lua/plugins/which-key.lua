return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    if not opts.defaults then
      opts.defaults = {}
    end
    -- Register our labels
    local wk = require("which-key")
    wk.add({
      { "<leader>W", group = "Windows" },
      { "<leader>w", desc = "Format + Save" },
    })
  end,
}
