return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
  ft = { "markdown" },
  config = function()
    -- 直接修改 treesitter 的 markdown 高亮组
    vim.api.nvim_set_hl(0, "@markup.strong", {
      fg = "#ff6b6b", -- 红色加粗
      bold = true,
    })

    vim.api.nvim_set_hl(0, "@markup.italic", {
      fg = "#4ecdc4", -- 青色斜体
      italic = true,
    })

    vim.api.nvim_set_hl(0, "@markup.strikethrough", {
      fg = "#95a5a6", -- 灰色删除线
      strikethrough = true,
    })

    -- 初始化插件，使用最基本的配置
    require("render-markdown").setup {}
  end,
}
