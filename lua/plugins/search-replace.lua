return {
  "roobert/search-replace.nvim",
  event = "VeryLazy",
  config = function()
    require("search-replace").setup {
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    }
  end,
  keys = {
    -- { "<leader>sf", "<CMD>SearchReplaceSingleBufferOpen<CR>", desc = "Search Replace in file" },
    -- { "<leader>sd", "<CMD>SearchReplaceSingleBufferCWord<CR>", desc = "Replace Word in file" },
  },
}
