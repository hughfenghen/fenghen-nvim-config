return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  ft = { "markdown" },
  config = function()
    ------------ markdown style ------------
    local function set_markdown_hl()
      vim.api.nvim_set_hl(0, "@markup.strong", {
        fg = "#ff6b6b",
        bold = true,
      })
      vim.api.nvim_set_hl(0, "@markup.italic", {
        fg = "#4ecdc4",
        italic = true,
      })
      vim.api.nvim_set_hl(0, "@markup.strikethrough", {
        fg = "#95a5a6",
        strikethrough = true,
      })
    end

    -- 主题加载 / 切换后重新应用
    -- 任何你想“最终生效”的高亮，一定要写在 ColorScheme autocmd 里
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_markdown_hl,
    })

    -- 首次手动调用一次（防止 colorscheme 已经加载过）
    set_markdown_hl()
    ------------ markdown style ------------

    -- 初始化插件，使用最基本的配置
    require("render-markdown").setup {}
  end,
}
