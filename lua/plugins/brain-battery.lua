return {
  "jaredxfeng/brain-battery.nvim",
  dependencies = {
    { "nvim-lualine/lualine.nvim", optional = true },
  },
  event = "VeryLazy",
  config = function(_, opts)
    require("brain-battery")._opts = opts
  end,
  opts = {
    capacity_minutes = 300,
    drain_rate = 1.1,
    coding_threshold_minutes = 2,
    recharge_minutes_per_break = 25,
  },
}
