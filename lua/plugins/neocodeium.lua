return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require "neocodeium"
    neocodeium.setup {
      -- 基本设置
      enabled = true,
      manual = false,
    }
  end,
  keys = {
    -- 接受整个建议
    {
      "<C-e>",
      function() require("neocodeium").accept() end,
      mode = "i",
      desc = "Accept suggestion",
    },
    -- 接受一个单词
    {
      "<A-w>",
      function() require("neocodeium").accept_word() end,
      mode = "i",
      desc = "Accept word",
    },
    -- 接受一行
    {
      "<A-a>",
      function() require("neocodeium").accept_line() end,
      mode = "i",
      desc = "Accept line",
    },
    -- 下一个建议
    {
      "<A-e>",
      function() require("neocodeium").cycle_or_complete() end,
      mode = "i",
      desc = "Next suggestion",
    },
    -- 上一个建议
    {
      "<A-r>",
      function() require("neocodeium").cycle_or_complete(-1) end,
      mode = "i",
      desc = "Previous suggestion",
    },
    -- 清除建议
    {
      "<A-c>",
      function() require("neocodeium").clear() end,
      mode = "i",
      desc = "Clear suggestions",
    },
    -- 手动完成（保留原有的）
    {
      "<C-.>",
      function() require("neocodeium").cycle_or_complete() end,
      mode = "i",
      desc = "Manual complete",
    },
  },
}
