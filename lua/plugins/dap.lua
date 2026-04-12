return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("configs.dap")   -- we'll create this next
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dapui = require("dapui")
      dapui.setup()

      -- Auto-open UI when debugging starts, close when it ends
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Optional but highly recommended: lets you install DAP servers with :MasonInstall
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        handlers = {}, -- auto-configures many common adapters
        ensure_installed = { "js-debug-adapter" }, -- add whatever you need
      })
    end,
  },
}
