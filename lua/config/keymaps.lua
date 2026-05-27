-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local buffer_util = require("config.buffer_util")

--- Like Snacks.bufdelete, but replacement buffer is never explorer/pickers (`snacks_*`, trees, etc.).
local function bufdelete_prefer_editor()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if vim.bo[buf].modified then
    local ok, choice = pcall(vim.fn.confirm, ("Save changes to %q?"):format(vim.fn.bufname(buf)), "&Yes\n&No\n&Cancel")
    if not ok or choice == 0 or choice == 3 then
      return
    elseif choice == 1 then
      vim.api.nvim_buf_call(buf, vim.cmd.write)
    end
  end

  local info = vim.fn.getbufinfo({ buflisted = 1 })
  info = vim.tbl_filter(function(b)
    return b.bufnr ~= buf and buffer_util.is_work_buffer(b.bufnr)
  end, info)
  table.sort(info, function(a, b)
    return a.lastused > b.lastused
  end)
  local fallback = info[1] and info[1].bufnr or vim.api.nvim_create_buf(true, false)

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    local target = fallback
    vim.api.nvim_win_call(win, function()
      local alt = vim.fn.bufnr("#")
      if alt >= 0 and alt ~= buf and vim.bo[alt].buflisted and buffer_util.is_work_buffer(alt) then
        target = alt
      end
    end)
    vim.api.nvim_win_set_buf(win, target)
  end

  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

-- Format + save on `<leader>w` (`nowait` so it does not wait for legacy `<leader>wd` / `<leader>wm`).
-- Delete window → `<leader>Wd`, zoom → `<leader>Wm` (LazyVim defaults relocated).
vim.keymap.set({ "n", "x" }, "<leader>w", function()
  LazyVim.format({ force = true })
  vim.cmd.write()
end, { desc = "Format & save", nowait = true })

pcall(vim.keymap.del, "n", "<leader>wd")
pcall(vim.keymap.del, "n", "<leader>wm")
vim.keymap.set("n", "<leader>Wd", "<C-W>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>Wm", function()
  local z = Snacks.toggle.get("zoom")
  if z then
    z:toggle()
  end
end, { desc = "Toggle zoom" })

-- Buffers (normal mode only — Tab is still free in insert mode for cmp/indent)
-- Note: <Tab> and <C-i> share the same keycode; this mapping shadows forward jumplist (<C-i>).
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader>Q", bufdelete_prefer_editor, { desc = "Close buffer" })
-- Override LazyVim default so closing never jumps the main window to Snacks explorer / tree.
vim.keymap.set("n", "<leader>bd", bufdelete_prefer_editor, { desc = "Delete Buffer" })

-- Explorer ↔ editor (Shift+h / Shift+l — overrides LazyVim buffer prev/next on these keys;
-- use Tab / Shift-Tab for buffers instead). <C-h> / <C-l> still work too.
vim.keymap.set("n", "<S-h>", "<C-w>h", { desc = "Go to Left Window (Explorer)", remap = true })
vim.keymap.set("n", "<S-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Optional: Alt+j,k — vertical splits (Meta in terminal: Kitty macos_option_as_alt; iTerm Esc+).
vim.keymap.set("n", "<M-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })

-- Arrow keys: move focus between windows (← left, → right, ↑ above, ↓ below).
-- Normal mode only (insert mode arrows still move the cursor).
-- Note: overrides LazyVim’s <Up>/<Down> for gj/gk on wrapped lines — use j/k for that instead.
vim.keymap.set("n", "<Left>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<Right>", "<C-w>l", { desc = "Go to Right Window", remap = true })
vim.keymap.set("n", "<Up>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<Down>", "<C-w>j", { desc = "Go to Lower Window", remap = true })

-- Cycle Snacks bottom terminals (same shell/cwd stack uses `vim.v.count` / id). See also `2<leader>ft` for slot 2.
local function snacks_terminal_cycle(delta)
  local list = Snacks.terminal.list()
  if #list == 0 then
    Snacks.notify.info("No Snacks terminals open")
    return
  end
  table.sort(list, function(a, b)
    local ia = vim.b[a.buf].snacks_terminal and vim.b[a.buf].snacks_terminal.id or a.buf
    local ib = vim.b[b.buf].snacks_terminal and vim.b[b.buf].snacks_terminal.id or b.buf
    return ia < ib
  end)
  local cur = vim.api.nvim_get_current_buf()
  local idx = nil
  for i, t in ipairs(list) do
    if t.buf == cur then
      idx = i
      break
    end
  end
  if not idx then
    idx = delta >= 0 and #list or 1
  else
    idx = ((idx - 1 + delta) % #list) + 1
  end
  list[idx]:show():focus()
  vim.cmd.startinsert()
end

vim.keymap.set("n", "<leader>ftn", function()
  snacks_terminal_cycle(1)
end, { desc = "Snacks terminal: next" })
vim.keymap.set("n", "<leader>ftp", function()
  snacks_terminal_cycle(-1)
end, { desc = "Snacks terminal: previous" })

-- Snacks terminal: in `t` mode keys normally go to the shell. Buffer-local maps (after FileType + schedule).
local function setup_snacks_terminal_keys(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.b[buf].snacks_term_keys_done then
    return
  end
  if vim.bo[buf].filetype ~= "snacks_terminal" then
    return
  end
  vim.b[buf].snacks_term_keys_done = true

  local function tmap(lhs, rhs, desc, remap)
    vim.keymap.set("t", lhs, rhs, { buffer = buf, remap = remap or false, desc = desc })
  end

  -- Leave terminal insert → Normal on this buffer, then `q` runs Snacks' hide mapping (remap must be true).
  tmap("<S-q>", "<C-\\><C-N>q", "Hide Snacks terminal", true)

  -- Same window motion as normal-mode arrows / LazyVim Ctrl-hjkl (remap false: literal keys).
  local leave = "<C-\\><C-N>"
  tmap("<Up>", leave .. "<C-w>k", "Focus window above")
  tmap("<Down>", leave .. "<C-w>j", "Focus window below")
  tmap("<Left>", leave .. "<C-w>h", "Focus window left")
  tmap("<Right>", leave .. "<C-w>l", "Focus window right")
  tmap("<C-k>", leave .. "<C-w>k", "Focus window above")
  tmap("<C-j>", leave .. "<C-w>j", "Focus window below")
  tmap("<C-h>", leave .. "<C-w>h", "Focus window left")
  tmap("<C-l>", leave .. "<C-w>l", "Focus window right")

  vim.keymap.set("t", "<M-n>", function()
    vim.schedule(function()
      snacks_terminal_cycle(1)
    end)
  end, { buffer = buf, desc = "Next Snacks terminal" })
  vim.keymap.set("t", "<M-p>", function()
    vim.schedule(function()
      snacks_terminal_cycle(-1)
    end)
  end, { buffer = buf, desc = "Previous Snacks terminal" })
end

local snacks_term_au = vim.api.nvim_create_augroup("SnacksTerminalKeys", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_terminal",
  group = snacks_term_au,
  callback = function(event)
    vim.schedule(function()
      setup_snacks_terminal_keys(event.buf)
    end)
  end,
})
-- Fallback: filetype can be set slightly after TermOpen; retry once shell is ready.
vim.api.nvim_create_autocmd("TermOpen", {
  group = snacks_term_au,
  callback = function(event)
    vim.schedule(function()
      setup_snacks_terminal_keys(event.buf)
    end)
  end,
})

-- Open terminal buffers in Snacks picker (fuzzy filter).
-- Enter: open that terminal in a Snacks *floating* window (default buffer jump uses splits/current win).
-- Ctrl+v / Ctrl+s still use vsplit/split via the picker’s usual actions.
local function pick_terminal_buffers()
  Snacks.picker.buffers({
    title = "Terminals",
    prompt = "Terminals ",
    hidden = true,
    unloaded = true,
    current = true,
    filter = {
      filter = function(item)
        return item.buftype == "terminal"
      end,
    },
    actions = {
      confirm = function(picker, item)
        if not item or not item.buf then
          return
        end
        picker:close()
        Snacks.win({
          buf = item.buf,
          relative = "editor",
          position = "float",
          enter = true,
          backdrop = 60,
          width = 0.85,
          height = 0.85,
          border = "rounded",
        }):show()
        if vim.bo[item.buf].buftype == "terminal" then
          vim.cmd.startinsert()
        end
      end,
    },
  })
end
vim.keymap.set("n", "<leader>bt", pick_terminal_buffers, { desc = "Terminal buffers" })
vim.api.nvim_create_user_command("Terminals", pick_terminal_buffers, { desc = "Pick an open terminal buffer" })

-- Rust: open docs.rs (and related) in the browser for the symbol under the cursor (rustaceanvim).
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  group = vim.api.nvim_create_augroup("RustOpenDocs", { clear = true }),
  callback = function(event)
    vim.keymap.set("n", "<leader>cE", function()
      vim.cmd.RustLsp("openDocs")
    end, { buffer = event.buf, desc = "Rust: Open external docs (docs.rs)" })
  end,
})
