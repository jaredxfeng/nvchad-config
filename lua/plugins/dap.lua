return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "banjo/package-pilot.nvim" },
    event = "VeryLazy",
    config = function()
      local dap = require("dap")

      -- === JavaScript / TypeScript Debug Adapter (robust version) ===
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "::1",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      local function pick_script()
        local pilot = require("package-pilot")

        local current_dir = vim.fn.getcwd()
        local package = pilot.find_package_file({ dir = current_dir })

        if not package then
          vim.notify("No package.json found", vim.log.levels.ERROR)
          return require("dap").ABORT
        end

        local scripts = pilot.get_all_scripts(package)

        local label_fn = function(script)
          return script
        end

        local co, ismain = coroutine.running()
        local ui = require("dap.ui")
        local pick = (co and not ismain) and ui.pick_one or ui.pick_one_sync
        local result = pick(scripts, "Select script", label_fn)
        return result or require("dap").ABORT
      end

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
            stopOnEntry = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to running process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Pick script (npm)",
            runtimeExecutable = "npm",
            runtimeArgs = function()     -- ← now lazily calls pick_script at launch time
              local script = pick_script()
              if script == require("dap").ABORT then
                return require("dap").ABORT
              end
              return { "run", script }
            end,
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            sourceMaps = true,
            stopOnEntry = true,
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

      -- === Auto-open/close DAP UI (moved here so it works even before you press <leader>du) ===
      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    keys = { "<leader>du "},
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
    lazy = true,
    keys = {       -- ← new: only loads on first debug keypress (removes the 170 ms from startup)
      "<leader>db",
      "<leader>dB",
      "<leader>dc",
      "<F5>",
      "<F10>",
      "<F11>",
      "<F12>",
      "<leader>du",
      "<leader>dr",
      "<leader>dR",
    },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        handlers = {},
        ensure_installed = { "js-debug-adapter" }, -- add others later if needed
      })
    end,
  },
}
