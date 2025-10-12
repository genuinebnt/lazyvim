return {
  {
    "mbbill/undotree",
    event = "VeryLazy",
    config = function()
      local ok, undotree = pcall(require, "undotree")
      if not ok then
        return
      end

      -- Configure undotree
      vim.g.undotree_WindowLayout = 2 -- Use vertical layout
      vim.g.undotree_ShortIndicators = 1 -- Use short indicators
      vim.g.undotree_SetFocusWhenToggle = 1 -- Set focus when toggling
      vim.g.undotree_HelpLine = 0 -- Hide help line
      vim.g.undotree_CursorLine = 1 -- Highlight current line
      vim.g.undotree_DiffAutoOpen = 0 -- Don't auto open diff
      vim.g.undotree_DiffpanelHeight = 10 -- Diff panel height
      vim.g.undotree_SplitWidth = 30 -- Split width
      vim.g.undotree_DiffCommand = "diff" -- Diff command
      vim.g.undotree_RelativeTimestamp = 1 -- Show relative timestamps
      vim.g.undotree_ShortIndicators = 1 -- Use short indicators
      vim.g.undotree_HelpLine = 0 -- Hide help line
      vim.g.undotree_CursorLine = 1 -- Highlight current line
      vim.g.undotree_DiffAutoOpen = 0 -- Don't auto open diff
      vim.g.undotree_DiffpanelHeight = 10 -- Diff panel height
      vim.g.undotree_SplitWidth = 30 -- Split width
      vim.g.undotree_DiffCommand = "diff" -- Diff command
      vim.g.undotree_RelativeTimestamp = 1 -- Show relative timestamps
    end,
    keys = {
      {
        "<leader>u",
        function()
          vim.cmd("UndotreeToggle")
        end,
        desc = "Toggle undotree",
        mode = "n",
      },
      {
        "<leader>U",
        function()
          vim.cmd("UndotreeFocus")
        end,
        desc = "Focus undotree",
        mode = "n",
      },
    },
  },
}
