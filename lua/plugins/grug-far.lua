return {
  "MagicDuck/grug-far.nvim",
  opts = {
    engine = "rg",
    -- engine = "ast-grep",
    windowCreationCommand = "vsplit",
  },
  keys = {
    {
      "<leader>sr",
      function() require("grug-far").open() end,
      desc = "Search and Replace",
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
