return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI" },
    config = function()
      -- Multiple database connections for honmono microservices
      vim.g.dbs = {
        -- Current services
        honmono_catalog = "postgresql://postgres:password@localhost:5432/honmono_store",
        
        -- Template for future services (uncomment and modify as needed):
        -- honmono_user = "postgresql://postgres:password@localhost:5433/user_service",
        -- honmono_order = "postgresql://postgres:password@localhost:5434/order_service",
        -- honmono_payment = "postgresql://postgres:password@localhost:5435/payment_service",
        -- honmono_inventory = "postgresql://postgres:password@localhost:5436/inventory_service",
      }
    end,
  },
  
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Database Buffer" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Database Buffer" },
      { "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
      -- Quick database switching
      { "<leader>dc", function() vim.b.db = vim.g.dbs.honmono_catalog end, desc = "Connect to Catalog DB" },
    },
    config = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 30
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_use_nvim_notify = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui_queries/honmono"
    end,
  },
  
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      -- Completion only works when manually connected to a database
      -- Use <leader>dc to connect, then you'll get SQL completion
      
      -- Disable automatic database connections
      -- Users can manually connect using :DB or <leader>dc
      
      -- Command to manually switch databases
      vim.api.nvim_create_user_command("HonmonoDBSwitch", function(opts)
        local db_name = "honmono_" .. opts.args
        if vim.g.dbs[db_name] then
          vim.b.db = vim.g.dbs[db_name]
          vim.notify("Switched to " .. db_name, vim.log.levels.INFO)
        else
          vim.notify("Database " .. db_name .. " not found", vim.log.levels.ERROR)
        end
      end, {
        nargs = 1,
        complete = function()
          local dbs = {}
          for name, _ in pairs(vim.g.dbs) do
            if string.find(name, "honmono_") then
              table.insert(dbs, string.gsub(name, "honmono_", ""))
            end
          end
          return dbs
        end,
        desc = "Switch to a honmono database connection"
      })
    end,
  },
}