return {
  name = "im-select-debug",
  dir = "/Users/fenghen/my-space/vim-im-select", -- 本地路径
  event = "InsertEnter",
  enabled = false,
  config = function()
    -- macOS 配置
    if vim.fn.has "mac" == 1 then
      vim.g.im_select_get_im_cmd = { "macism" }
      vim.g.ImSelectSetImCmd = function(key)
        local cmd = { "macism", key }
        return cmd
      end

      vim.g.im_select_default = "com.apple.keylayout.ABC"
      vim.g.im_select_native_im = "com.tencent.inputmethod.wetype.pinyin"
    elseif vim.fn.has "win32" == 1 then
      vim.g.im_select_get_im_cmd = { "im-select.exe" }
      vim.g.im_select_default = "1033"
    end

    -- 修正配置变量名
    vim.g.im_select_switch_timeout = 100
    vim.g.im_select_enable_focus_events = 1
    vim.g.im_select_enable_cmd_line = 1
  end,
}
