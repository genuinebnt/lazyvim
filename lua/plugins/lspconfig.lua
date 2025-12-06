return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              procMacro = {
                enable = true,
                ignored = {
                  -- Remove async_trait from ignored macros list
                  -- by explicitly NOT including it here
                },
              },
            },
          },
        },
      },
    },
  },
}
