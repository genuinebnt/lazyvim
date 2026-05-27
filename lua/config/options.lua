-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Rust: surface cargo/check diagnostics via bacon-ls (see LazyVim rust extra).
-- Install CLI tools once:  cargo install --locked bacon bacon-ls
-- Mason can install the `bacon` package; `bacon-ls` must be on PATH (same cargo install).
vim.g.lazyvim_rust_diagnostics = "bacon-ls"
