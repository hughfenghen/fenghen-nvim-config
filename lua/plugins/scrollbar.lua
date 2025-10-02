return {
  "petertriho/nvim-scrollbar",
  enabled = false,
  config = function()
    require("scrollbar").setup()
    require("scrollbar.handlers.gitsigns").setup()
  end,
}
