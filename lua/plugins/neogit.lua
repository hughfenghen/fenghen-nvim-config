return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    -- "sindrets/diffview.nvim", -- optional - Diff integration
    "esmuellert/codediff.nvim", -- optional
    "folke/snacks.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    -- { "<leader>gn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  config = function() require("neogit").setup { fetch_after_checkout = true } end,
}
