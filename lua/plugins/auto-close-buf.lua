return {
  "chrisgrieser/nvim-early-retirement",
  event = "VeryLazy",
  config = function()
    require("early-retirement").setup {
      retirementAgeMins = 60,
      minimumBufferNum = 5,
    }
  end,
}
