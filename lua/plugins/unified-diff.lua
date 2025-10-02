return {
  "axkirillov/unified.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    require("unified").setup()
    vim.keymap.set("n", "<leader>gd", function() require("unified").toggle() end, { desc = "inline git diff" })
  end,
}
