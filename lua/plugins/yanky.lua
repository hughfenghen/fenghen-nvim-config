return {
  "gbprod/yanky.nvim",
  opts = {},
  config = function()
    require("yanky").setup()
    -- 设置粘贴时的高亮颜色
    vim.api.nvim_set_hl(0, "YankyPut", { link = "IncSearch" })

    -- 设置复制时的高亮颜色
    vim.api.nvim_set_hl(0, "YankyYanked", { link = "IncSearch" })
  end,
}
