return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { multi_window = true } }) end, desc = "Flash Multi Window" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter() end, desc = "Treesitter Flash" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
