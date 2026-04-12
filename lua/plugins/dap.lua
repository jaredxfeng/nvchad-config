return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",                    -- ← forces early loading so keymaps work immediately
    config = function()
      local dap = require("dap")

      -- === JavaScript / TypeScript Debug Adapter ===
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "::1",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      for _, ft in ipairs(js_filetypes) do
        dap.configurations[ft] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (Node.js)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to running process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
        }
      end

      -- === Your keymaps (exactly what you asked for) ===
      local map = vim.keymap.set

      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "DAP: Set conditional breakpoint" })

      map("n", "<leader>dc", dap.clear_breakpoints, { desc = "DAP: Clear ALL breakpoints" })

      map("n", "<F5>", dap.continue, { desc = "DAP: Continue / Run to next breakpoint" })
      map("n", "<F10>", dap.step_over, { desc = "DAP: Step over" })
      map("n", "<F11>", dap.step_into, { desc = "DAP: Step into" })
      map("n", "<F12>", dap.step_out, { desc = "DAP: Step out" })

      map("n", "<leader>du", function()
        require("dapui").toggle()
      end, { desc = "DAP: Toggle debug side panels" })

      map("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open debug console (REPL)" })
      map("n", "<leader>dR", dap.repl.close, { desc = "DAP: Close debug console (REPL)" }) 

      vim.notify("✅ DAP + TypeScript debugging ready!", vim.log.levels.INFO)
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dapui = require("dapui")
      dapui.setup()

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

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        handlers = {},
        ensure_installed = { "js-debug-adapter" }, -- add others later if needed
      })
    end,
  },
}
