return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("marks").setup {
      mappings = {
        set_next = false,
        next = "m.",
        prev = "m,",
      },
    }
  end,
}
