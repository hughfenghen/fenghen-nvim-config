return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    { "R", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "r", mode = { "o", "x" }, function() require("flash").treesitter() end, desc = "Treesitter Flash" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
