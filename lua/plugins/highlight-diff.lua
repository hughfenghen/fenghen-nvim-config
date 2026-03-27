return {
  "barrettruth/diffs.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.diffs = {
      integrations = {
        -- fugitive = true,
        neogit = true,
        -- neojj = true,
        gitsigns = true,
      },
    }
  end,
}
