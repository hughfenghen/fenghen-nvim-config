return {
  -- name = "fenghen-im-select",
  -- dir = "/Users/fenghen/my-space/fenghen-im-select.nvim", -- 本地路径
  "hughfenghen/fenghen-im-select.nvim",
  -- enabled = false,
  config = function()
    local im_select = require "im_select.init"

    ---@type im_select.Config
    local opts = {}

    local im_select_native_im = nil
    local im_select_default = nil

    -- macOS 配置
    if vim.fn.has "mac" == 1 then
      opts.im_select_get_im_cmd = { "macism" }
      opts.ImSelectSetImCmd = function(key)
        local cmd = { "macism", key }
        return cmd
      end

      im_select_native_im = "com.tencent.inputmethod.wetype.pinyin"
      im_select_default = "com.apple.keylayout.ABC"
      opts.im_select_default = im_select_default
      opts.im_select_native_im = im_select_native_im
    elseif vim.fn.has "win32" == 1 then
      opts.im_select_get_im_cmd = { "im-select.exe" }

      im_select_default = "1033"
      opts.im_select_default = im_select_default
    end

    -- 光标插入时的切换策略
    opts.insert_enter_strategies = {
      -- 如果光标前是中文字符，切换到拼音输入法
      function(ctx)
        local nr = ctx.charcode_before or ctx.charcode_after or 0
        if nr >= 0x4E00 and nr <= 0x9FFF or nr >= 0x3000 and nr <= 0x303F or nr >= 0xFF00 and nr <= 0xFFEF then
          return im_select_native_im
        end
      end,
      -- 如果光标前是英文字母，切换英文输入法
      function(ctx)
        local ch = ctx.char_before or ctx.char_after or ""
        if ch:match "[a-zA-Z]" then return im_select_default end
      end,
      -- 如果源代码（tsx，jsx，lua，html，css），注释行切换中文，否则切换英文
      function(ctx)
        local valid_types = {
          typescript = true,
          typescriptreact = true,
          javascript = true,
          javascriptreact = true,
          lua = true,
          html = true,
          css = true,
          python = true,
        }
        local is_match = valid_types[ctx.filetype]
        if is_match then
          if ctx.is_inside_comment then
            return im_select_native_im
          else
            return im_select_default
          end
        end
      end,

      -- 如果光标前是空格，切换到上次使用的输入法
      -- function(ctx)
      --   local nr = ctx.charcode_before or 0
      --   if nr == 0x0020 or nr == 0x3000 then return im_select.get_prev_im() end
      -- end,

      -- Markdown 默认切换至中文
      function(ctx)
        if ctx.filetype == "markdown" then return im_select_native_im end
      end,
      -- 兜底切换至英文
      function() return im_select_default end,
    }

    opts.im_select_switch_timeout = 100
    opts.im_select_enable_focus_events = 1
    opts.im_select_enable_cmd_line = 1

    im_select.setup(opts)
  end,
}
