return {
  dir = "~/my-space/flowerfield.nvim",
  name = "flowerfield",
  enabled = false,
  config = function()
    vim.cmd "colorscheme flowerfield-light"
    -- vim.cmd "colorscheme flowerfield-dark"
  end,
}
