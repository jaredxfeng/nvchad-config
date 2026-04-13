return {
  "pwntester/octo.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
  cmd = "Octo",
  lazy = true,
  config = function()
    require("octo").setup()
  end,
}
