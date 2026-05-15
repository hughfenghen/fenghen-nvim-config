return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    -- Your setup opts here
    outline_window = {
      -- Where to open the split window: right/left
      position = "left",
    },
    outline_items = {
      show_symbol_details = true, -- 启用详细信息显示
    },
  },
}
