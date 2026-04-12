return {
  {
    "stevearc/aerial.nvim",
    lazy = true,
    cmd = { "AerialToggle" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Put any custom options here (optional).
      -- Full list of options: https://github.com/hedyhli/outline.nvim
      -- Example: move outline to the right side
      position = "right",
    },
  },
}
