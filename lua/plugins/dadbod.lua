return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI" },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      local function get_dev_db_url()
        local dev_db_url = vim.env.DEV_DB_URL or ""
        if dev_db_url == "" then
          local f = io.open(vim.fn.expand("~/.dev_db_url"), "r")
          if f then
            dev_db_url = f:read("*l") or ""
            f:close()
          end
        end
        if dev_db_url ~= "" then
          dev_db_url = dev_db_url:gsub("^postgres://", "postgresql://")
        end
        return dev_db_url
      end
      -- Multiple database connections for honmono microservices
      vim.g.dbs = {
        -- Current services - uses DEV_DB_URL env variable
        honmono_catalog = get_dev_db_url(),
        
        -- Template for future services (uncomment and modify as needed):
        -- honmono_user = "postgresql://postgres:password@localhost:5433/user_service",
        -- honmono_order = "postgresql://postgres:password@localhost:5434/order_service",
        -- honmono_payment = "postgresql://postgres:password@localhost:5435/payment_service",
        -- honmono_inventory = "postgresql://postgres:password@localhost:5436/inventory_service",
      }

      local dev_db_url = get_dev_db_url()
      if dev_db_url ~= "" then
        vim.g.db = dev_db_url
      end

      local group = vim.api.nvim_create_augroup("DadbodDevDB", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          local current_dev_db_url = get_dev_db_url()
          if current_dev_db_url ~= "" then
            vim.g.dbs.honmono_catalog = current_dev_db_url
            vim.g.db = current_dev_db_url
            vim.b.db = current_dev_db_url
          else
            vim.notify("No DB selected — use <leader>ds to pick one", vim.log.levels.WARN)
          end
          vim.keymap.set("n", "<leader>se", "vip:DB<CR>", { buffer = true, silent = true, desc = "Execute SQL paragraph" })
          vim.keymap.set("v", "<leader>se", ":DB<CR>", { buffer = true, silent = true, desc = "Execute SQL selection" })
          vim.keymap.set("n", "<leader>sl", ":.DB<CR>", { buffer = true, silent = true, desc = "Execute SQL line" })
        end,
      })

      if vim.fn.exists(":DBReconnect") == 2 then
        vim.api.nvim_del_user_command("DBReconnect")
      end
      vim.api.nvim_create_user_command("DBReconnect", function()
        local current_dev_db_url = get_dev_db_url()
        if current_dev_db_url ~= "" then
          vim.g.dbs.honmono_catalog = current_dev_db_url
          vim.g.db = current_dev_db_url
          vim.b.db = current_dev_db_url
          vim.notify("Reconnected using DEV_DB_URL", vim.log.levels.INFO)
        else
          vim.notify("No DB selected — use <leader>ds to pick one", vim.log.levels.ERROR)
        end
      end, { desc = "Reconnect Dadbod using DEV_DB_URL" })
    end,
  },
  
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Database Buffer" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Database Buffer" },
      { "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
      -- Quick database switching
      {
        "<leader>ds",
        function()
          local entries = {
            { label = "bittree_document", url = "postgres://bittree:bittree@localhost:5432/bittree_document" },
            { label = "bittree_test",     url = "postgres://bittree:bittree@localhost:5432/bittree_test" },
          }
          local labels = vim.tbl_map(function(e) return e.label end, entries)
          vim.ui.select(labels, { prompt = "Select database:" }, function(choice)
            if not choice then return end
            for _, e in ipairs(entries) do
              if e.label == choice then
                local raw_url = e.url
                local f = io.open(vim.fn.expand("~/.dev_db_url"), "w")
                if f then f:write(raw_url) f:close() end
                local url = raw_url:gsub("^postgres://", "postgresql://")
                vim.env.DEV_DB_URL = raw_url
                vim.g.db = url
                vim.b.db = url
                vim.notify("Switched to " .. choice, vim.log.levels.INFO)
                break
              end
            end
          end)
        end,
        desc = "Switch database connection",
      },
      {
        "<leader>dc",
        function()
          local dev_db_url = vim.env.DEV_DB_URL or ""
          if dev_db_url ~= "" then
            dev_db_url = dev_db_url:gsub("^postgres://", "postgresql://")
            vim.g.dbs.honmono_catalog = dev_db_url
            vim.b.db = dev_db_url
            vim.g.db = dev_db_url
            vim.notify("Connected using DEV_DB_URL", vim.log.levels.INFO)
            return
          end
          vim.notify("DEV_DB_URL is not set", vim.log.levels.ERROR)
        end,
        desc = "Connect using DEV_DB_URL",
      },
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
