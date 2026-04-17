return {
  "MagicDuck/grug-far.nvim",
  opts = {
    engine = "rg",
    -- engine = "astgrep",
    windowCreationCommand = "vsplit",
  },
  keys = {
    {
      "<leader>sr",
      function() require("grug-far").open() end,
      desc = "Search and Replace",
    },
    {
      "<leader>sR",
      function() require("grug-far").open { engine = "astgrep" } end,
      desc = "Search and Replace (astgrep)",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").open {
          prefills = { search = vim.fn.expand "<cword>" },
        }
      end,
      desc = "Search current word",
    },
  },
}
