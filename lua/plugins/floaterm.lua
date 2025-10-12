return {
  -- Floating terminal plugin
  {
    "voldikss/vim-floaterm",
    cmd = { "FloatermNew", "FloatermToggle", "FloatermHide", "FloatermKill" },
    keys = {
      -- Toggle floating terminal
      {
        "<leader>ft",
        function()
          vim.cmd("FloatermToggle")
          -- Enter insert mode when terminal becomes visible
          if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
          end
        end,
        desc = "Toggle floating terminal",
        mode = "n",
      },
      -- Navigate between terminal tabs (when in terminal mode)
      {
        "<Tab>",
        function()
          vim.cmd("FloatermNext")
        end,
        desc = "Next terminal tab",
        mode = "t", -- terminal mode only
      },
      {
        "<S-Tab>",
        function()
          vim.cmd("FloatermPrev")
        end,
        desc = "Previous terminal tab",
        mode = "t", -- terminal mode only
      },
      -- Hide floating terminal (removed q keybinding, only Esc available)
      -- Exit/kill floating terminal
      {
        "<S-q>",
        function()
          vim.cmd("FloatermKill")
        end,
        desc = "Exit floating terminal",
        mode = "t", -- terminal mode
      },
      -- Escape from terminal (hide terminal)
      {
        "<Esc>",
        function()
          vim.cmd("FloatermHide")
        end,
        desc = "Hide floating terminal",
        mode = "t",
      },
      -- Create new terminal tab
      {
        "<leader>fn",
        function()
          vim.cmd("FloatermNew")
          vim.cmd("startinsert")
        end,
        desc = "New terminal tab",
        mode = "n",
      },
    },
    opts = {
      -- Configuration for floaterm
      floaterm = {
        -- Position and size
        position = "center",
        width = 0.8,
        height = 0.8,
        -- Appearance
        borderchars = "─│─│┌┐┘└",
        title = "Terminal",
        -- Behavior
        autoclose = 2,     -- Close terminal when job ends
        autoinsert = true, -- Auto enter insert mode
        -- Style
        winblend = 10,     -- Transparency
        wintype = "floating",
      },
    },
    config = function(_, opts)
      -- Set up floaterm configuration
      for key, value in pairs(opts.floaterm) do
        vim.g["floaterm_" .. key] = value
      end

      -- Auto enter insert mode when terminal is opened
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
          if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
          end
        end,
      })

      -- Auto enter insert mode when switching to terminal buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
          end
        end,
      })
    end,
  },
}
