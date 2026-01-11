-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  "brglng/vim-im-select",
  event = "InsertEnter",
  -- enabled = false,
  config = function()
    -- macOS 配置
    if vim.fn.has "mac" == 1 then
      vim.g.im_select_get_im_cmd = { "macism" }
      vim.g.ImSelectSetImCmd = function(key)
        local cmd = { "macism", key }
        -- vim.notify(string.format("SET IM: key=%s, cmd=%s", key, table.concat(cmd, " ")), vim.log.levels.INFO)
        return cmd
      end

      vim.g.im_select_default = "com.apple.keylayout.ABC"
    elseif vim.fn.has "win32" == 1 then
      vim.g.im_select_get_im_cmd = { "im-select.exe" }
      vim.g.im_select_default = "1033"
    end

    -- 修正配置变量名
    vim.g.im_select_switch_timeout = 100
    vim.g.im_select_enable_focus_events = 1
    vim.g.im_select_enable_cmd_line = 1

    -- 使用 notify 记录回调函数
    -- vim.g.ImSelectGetImCallback = function(exit_code, stdout, stderr)
    --   local stdout_str = type(stdout) == "table" and table.concat(stdout, "") or stdout
    --   local stderr_str = type(stderr) == "table" and table.concat(stderr, "") or stderr
    --
    --   -- vim.notify(
    --   --   string.format("GET IM: exit=%d, stdout=%s, stderr=%s", exit_code, stdout_str, stderr_str),
    --   --   vim.log.levels.INFO
    --   -- )
    --
    --   return stdout_str
    -- end
  end,
}
