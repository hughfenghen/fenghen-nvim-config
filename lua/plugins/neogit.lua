return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "folke/snacks.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  config = function()
    require("neogit").setup {}

    local actions = require "diffview.actions"
    require("diffview").setup {
      enhanced_diff_hl = true, -- 启用增强的差异高亮
      keymaps = {
        view = {
          ["<leader>b"] = function()
            actions.toggle_files()
            -- 平衡窗口大小
            vim.cmd "wincmd ="
          end,
        },
        file_panel = {
          ["<leader>b"] = function()
            actions.toggle_files()
            vim.cmd "wincmd ="
          end,
        },
      },
    }
    -- 高亮差异颜色
    -- vim.api.nvim_set_hl(0, "DiffText", {
    --   bg = "#503030",
    --   bold = true,
    -- })
  end,
}
