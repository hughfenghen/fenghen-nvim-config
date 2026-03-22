return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    -- Highlight configuration
    highlights = {
      char_insert = "#86F297",
      char_delete = "#FF9D9E",
    },
    diff = {
      layout = "inline",
    },
  },
  keys = {
    {
      "<leader>gd",
      function()
        -- 关闭左侧 explorer（如果存在）
        local current_tab = vim.api.nvim_get_current_tabpage()
        local lifecycle = require "codediff.ui.lifecycle"
        local explorer_obj = lifecycle.get_explorer(current_tab)

        if explorer_obj then
          local explorer = require "codediff.ui.explorer"
          explorer.toggle_visibility(explorer_obj)
        end

        -- 对当前文件执行 git diff
        vim.cmd "CodeDiff file HEAD"
      end,
      desc = "diff this",
    },
  },
}
