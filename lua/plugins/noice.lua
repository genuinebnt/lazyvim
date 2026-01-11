return {
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      -- Add error handling for treesitter integration
      lsp = {
        -- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- Add error handling for message processing
      messages = {
        -- NOTE: If you enable messages, then the "cmdline" window is set to the height of the message window.
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      -- Add error handling for popupmenu
      popupmenu = {
        enabled = true,
        backend = "nui",
        kind_icons = {},
      },
      -- Add error handling for cmdline
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          -- Disable treesitter parsing for cmdline to prevent query errors
          cmdline = { pattern = "^:", icon = ":", lang = "vim" },
          search_down = { icon = "🔍⌄", lang = "regex" },
          search_up = { icon = "🔍⌃", lang = "regex" },
          filter = { icon = "$", lang = "bash" },
          lua = { icon = "☕", lang = "lua" },
          help = { icon = "?", lang = "vim" },
        },
        -- Disable treesitter integration for cmdline
        format_filter = function(_, opts)
          return opts
        end,
      },
      -- Add error handling for notify
      notify = {
        enabled = true,
        view = "notify",
      },
      -- Add error handling for lsp progress
      lsp_progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30, -- frequency to update lsp progress message
        view = "mini",
      },
      -- Add error handling for hover
      hover = {
        enabled = true,
        view = nil, -- when nil, use defaults from documentation
        opts = {},
      },
      -- Add error handling for signature
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
        view = nil, -- when nil, use defaults from documentation
        opts = {},
      },
      -- Add error handling for documentation
      documentation = {
        view = "hover",
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "", conceallevel = 0 },
        },
      },
    },
    config = function(_, opts)
      local ok, noice = pcall(require, "noice")
      if not ok then
        return
      end
      
      noice.setup(opts)
      
      -- Add error handling for treesitter query integration
      local query_ok, query = pcall(require, "nvim-treesitter.query")
      if query_ok and query.get_query then
        -- Wrap query functions with error handling
        local original_get_query = query.get_query
        query.get_query = function(lang, query_name)
          local success, result = pcall(original_get_query, lang, query_name)
          if not success then
            -- Silently handle query parsing errors
            return nil
          end
          return result
        end
      end
    end,
  },
}
