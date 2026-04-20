require("nvchad.configs.lspconfig").defaults()

-- Tell pyright to use your mise-managed Python (this is the only extra config we need)
vim.lsp.config.pyright = {
  settings = {
    python = {
      pythonPath = vim.fn.exepath("python"),  -- this resolves to your mise shim
    },
  },
}

local servers = { "html", "cssls", "ts_ls", "pyright" }
vim.lsp.enable(servers)
