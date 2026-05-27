-- Window hydra: <leader>W (not <leader>w — that is format & save in keymaps.lua).
return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local function move_windows_proxy(block)
        if type(block) ~= "table" then
          return
        end
        for _, entry in pairs(block) do
          if
            type(entry) == "table"
            and type(entry[1]) == "string"
            and entry[1] == "<leader>w"
            and entry.group == "windows"
            and entry.proxy
          then
            entry[1] = "<leader>W"
          end
        end
      end
      for _, spec_block in ipairs(opts.spec or {}) do
        move_windows_proxy(spec_block)
      end
    end,
  },
}
