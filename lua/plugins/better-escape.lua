return {
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      local ok, better_escape = pcall(require, "better_escape")
      if not ok then
        return
      end

      better_escape.setup({
        -- Key mappings to escape insert mode
        mapping = { "jk", "kj", "jj" }, -- You can add more mappings here
        -- Timeout in milliseconds
        timeout = 200,
        -- Clear highlight groups on escape
        clear_empty_lines = false,
        -- Keys that trigger escape
        keys = function()
          return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
        end,
      })
    end,
  },
}
