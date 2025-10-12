return {
  -- Fix nvim-dap configuration to prevent setup errors
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        optional = true,
        config = function()
          -- Only configure if python debugpy is available
          local dap_python_ok, dap_python = pcall(require, "dap-python")
          if dap_python_ok then
            -- Try to find python path
            local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
            if python_path and python_path ~= "" then
              dap_python.setup(python_path)
            end
          end
        end,
      },
    },
    config = function()
      -- Basic DAP configuration
      local dap_ok, dap = pcall(require, "dap")
      if not dap_ok then
        return
      end

      -- Set up basic DAP signs
      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "◐",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "○",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "",
      })
    end,
  },
}