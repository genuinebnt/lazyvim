--- Shared helpers for “real editor” buffers vs UI (explorer, pickers, etc.).
local M = {}

--- Filetypes treated as UI-only side panels / ephemeral views.
local ephemeral_ft = {
  ["neo-tree"] = true,
  ["neo-tree-popup"] = true,
  ["NvimTree"] = true,
  ["Outline"] = true,
  ["aerial"] = true,
  ["undotree"] = true,
  ["qf"] = true,
  ["help"] = true,
}

--- Buffers that count as normal editable “work” (not explorer, terminals, scratch empty).
function M.is_work_buffer(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  if not vim.bo[buf].buflisted then
    return false
  end
  local bt = vim.bo[buf].buftype
  if bt == "terminal" or bt == "prompt" then
    return false
  end
  if bt ~= "" then
    return false
  end
  local ft = vim.bo[buf].filetype
  if ephemeral_ft[ft] then
    return false
  end
  if ft:match("^snacks_") then
    return false
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" and not vim.bo[buf].modified then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines == 0 or (#lines == 1 and vim.trim(lines[1] or "") == "") then
      return false
    end
  end
  return true
end

return M
