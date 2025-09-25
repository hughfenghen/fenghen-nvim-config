return {
  "chrisgrieser/nvim-early-retirement",
  event = "VeryLazy",
  config = function()
    require("early-retirement").setup {
      retirementAgeMins = 60 * 5,
      minimumBufferNum = 10,
      -- notificationOnAutoClose = true, -- 启用通知以确认插件工作
      -- ignoreVisibleBufs = false, -- 允许关闭可见缓冲区（谨慎使用）
    }
  end,
}
