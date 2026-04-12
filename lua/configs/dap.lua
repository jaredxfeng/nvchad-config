local dap = require("dap")
local dapui = require("dapui")
local map = vim.keymap.set

-- === Your requested functionality ===
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint on current line" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Set conditional breakpoint" })

map("n", "<leader>dc", dap.clear_breakpoints, { desc = "DAP: Clear ALL breakpoints" })

map("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle debug side panels (variables, stack, console, etc.)" })

-- Step commands (standard F-keys work great)
map("n", "<F5>", dap.continue, { desc = "DAP: Continue / Run to next breakpoint" })
map("n", "<F10>", dap.step_over, { desc = "DAP: Step over" })
map("n", "<F11>", dap.step_into, { desc = "DAP: Step into" })
map("n", "<F12>", dap.step_out, { desc = "DAP: Step out" })

-- Extra useful ones
map("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open debug console (REPL)" })
map("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "DAP: Hover/watch variable under cursor" })

-- Optional: Which-key friendly group (shows up in NvCheatsheet)
local which_key = require("which-key")
which_key.add({
  { "<leader>d", group = "Debug" },
})
