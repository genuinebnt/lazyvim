-- Disable Shift+h/l on bufferline so config/keymaps.lua can use them for window left/right.
return {
  {
    "akinsho/bufferline.nvim",
    optional = true,
    keys = {
      { "<S-h>", false },
      { "<S-l>", false },
    },
  },
}
