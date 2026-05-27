return {
  -- Floating terminal (vim-floaterm). Separate from LazyVim/Snacks bottom terminal (<leader>ft).
  -- Snacks: bottom split terminal — <leader>ft, <leader>fT (cwd), <c-/>
  -- Floaterm: centered float — <leader>fz toggle, <leader>fN new floaterm
  {
    "voldikss/vim-floaterm",
    cmd = { "FloatermNew", "FloatermToggle", "FloatermHide", "FloatermKill" },
    keys = {
      -- Toggle floating terminal (do not use <leader>ft — that is Snacks terminal)
      {
        "<leader>fz",
        function()
          vim.cmd("FloatermToggle")
          -- Enter insert mode when terminal becomes visible
          if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
          end
        end,
        desc = "Floaterm (float)",
        mode = "n",
      },
      -- Terminal-mode keys moved to FileType=floaterm (see config) — global `t` maps broke Snacks terminals (e.g. <S-q> → FloatermKill error).
      -- New floaterm instance (do not use <leader>fn — LazyVim uses that for :enew)
      {
        "<leader>fN",
        function()
          vim.cmd("FloatermNew")
          vim.cmd("startinsert")
        end,
        desc = "Floaterm new (float)",
        mode = "n",
      },
      -- Simple navigation from normal mode
      {
        "<leader>tn",
        function()
          vim.cmd("FloatermNext")
        end,
        desc = "Next terminal",
        mode = "n",
      },
      {
        "<leader>tp",
        function()
          vim.cmd("FloatermPrev")
        end,
        desc = "Previous terminal",
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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "floaterm",
        group = vim.api.nvim_create_augroup("floaterm_terminal_keys", { clear = true }),
        callback = function(event)
          local buf = event.buf
          vim.keymap.set("t", "<Tab>", function()
            vim.cmd("FloatermNext")
          end, { buffer = buf, desc = "Floaterm next" })
          vim.keymap.set("t", "<S-Tab>", function()
            vim.cmd("FloatermPrev")
          end, { buffer = buf, desc = "Floaterm prev" })
          vim.keymap.set("t", "<S-q>", function()
            vim.cmd("FloatermKill")
          end, { buffer = buf, desc = "Floaterm kill" })
          vim.keymap.set("t", "<Esc>", function()
            vim.cmd("FloatermHide")
          end, { buffer = buf, desc = "Floaterm hide" })
        end,
      })

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
