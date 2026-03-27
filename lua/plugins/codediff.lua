return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    -- Highlight configuration
    highlights = {
      char_insert = "#86E297",
      char_delete = "#FF9D9E",
    },
    diff = {
      layout = "inline",
    },
    keymaps = {
      view = {
        -- next_file = "]f", -- Next file in explorer/history mode
        -- prev_file = "[f", -- Previous file in explorer/history mode
        next_file = "<Tab>", -- Next file in explorer/history mode
        prev_file = "<S-Tab>", -- Previous file in explorer/history mode
      },
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
    {
      "<leader>gC",
      "<cmd>CodeDiff history<cr>",
      desc = "CodeDiff history",
    },
    {
      "<leader>gc",
      function()
        local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~")
        vim.cmd("CodeDiff history " .. file)
      end,
      desc = "CodeDiff current file history",
    },
    {
      "<leader>gm",
      function()
        local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~")
        vim.cmd("CodeDiff merge " .. file)
      end,
      desc = "CodeDiff merge view",
    },
  },
}
