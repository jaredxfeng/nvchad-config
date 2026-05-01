return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "jaredxfeng/brain-battery.nvim" },  -- ← this ensures correct load order
  event = "VeryLazy",
  opts = function(_, opts)
    opts.sections = opts.sections or {}
    opts.sections.lualine_b = {
        "branch",
        {
          function()
            local statusline = require("arrow.statusline")
            return statusline.text_for_statusline_with_icons()
          end,
        },
    }
    opts.sections.lualine_x = vim.list_extend(
      opts.sections.lualine_x or {},
      { require("brain-battery").lualine_component() }
    )
    return opts
  end,
}
