-- 创建自动命令组
vim.api.nvim_create_augroup("FixLeftWindow", { clear = true })

vim.api.nvim_create_autocmd({ "WinNew", "WinClosed" }, {
  group = "FixLeftWindow",
  callback = function()
    local wins = vim.api.nvim_list_wins()
    if #wins > 1 then
      -- 找到最左侧的窗口（列位置最小）
      local leftmost_win = nil
      local min_col = math.huge

      for _, win in ipairs(wins) do
        local pos = vim.api.nvim_win_get_position(win)
        if pos[2] < min_col then
          min_col = pos[2]
          leftmost_win = win
        end
      end

      if leftmost_win then
        vim.api.nvim_set_option_value("winfixwidth", true, { win = leftmost_win })
        vim.api.nvim_win_set_width(leftmost_win, 65)
      end
    end
  end,
})
