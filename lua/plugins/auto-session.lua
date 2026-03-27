-- plugins/auto-session.lua
return {
  "rmagatti/auto-session",
  -- 该插件不能延迟加载
  config = function()
    require("auto-session").setup {
      log_level = "error",
      allowed_dirs = { "~/my-space/*", "~/bili-space/*", "~/.config/*", "~/Movies/*" },

      -- 关键配置：当用 nvim 打开目录时也恢复会话
      auto_session_create_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,

      -- 与 yazi 兼容的配置
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
      },
    }
  end,
}
