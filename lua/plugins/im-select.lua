-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  "brglng/vim-im-select",
  event = "InsertEnter",
  config = function()
    -- macOS 配置
    if vim.fn.has "mac" == 1 then
      vim.g.im_select_get_im_cmd = { "macism" }
      vim.g.im_select_default = "com.apple.keylayout.ABC"
    -- Windows 配置
    elseif vim.fn.has "win32" == 1 then
      vim.g.im_select_get_im_cmd = { "im-select.exe" }
      vim.g.im_select_default = "1033"
      -- Linux 配置（自动检测）
    end

    -- 可选配置
    vim.g.im_select_timeout = 100 -- 防抖超时时间（毫秒）
    vim.g.im_select_enable_focus_events = 1 -- 启用焦点事件
    vim.g.im_select_enable_cmdline_mode = 1 -- 命令行模式也切换输入法
  end,
}
