if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    -- 1. 先定义组件
    local NeoCodeium = {
      static = {
        symbols = {
          status = {
            [0] = "󰚩 ", -- Enabled
            [1] = "󱚧 ", -- Disabled Globally
            [2] = "󱙻 ", -- Disabled for Buffer
            [3] = "󱙺 ", -- Disabled for Buffer filetype
            [4] = "󱙺 ", -- Disabled for Buffer with enabled function
            [5] = "󱚠 ", -- Disabled for Buffer encoding
            [6] = "󱚠 ", -- Buffer is special type
          },
          server_status = {
            [0] = "󰣺 ", -- Connected
            [1] = "󰣻 ", -- Connecting
            [2] = "󰣽 ", -- Disconnected
          },
        },
      },
      update = {
        "User",
        pattern = { "NeoCodeiumServer*", "NeoCodeium*{En,Dis}abled" },
        callback = function() vim.cmd.redrawstatus() end,
      },
      provider = function(self)
        local symbols = self.symbols
        local status, server_status = require("neocodeium").get_status()
        return symbols.status[status] .. symbols.server_status[server_status]
      end,
      hl = { fg = "yellow" },
    }
    table.insert(opts.statusline, NeoCodeium)

    local utils = require "heirline.utils"
    local conditions = require "heirline.conditions"

    -- 状态栏显示文件路径
    local FileNameBlock = {
      init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
    }
    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then return "[No Name]" end
        if not conditions.width_percent_below(#filename, 0.25) then filename = vim.fn.pathshorten(filename, 3) end
        return filename
      end,
      hl = { fg = utils.get_highlight("Directory").fg },
    }

    FileNameBlock = utils.insert(FileNameBlock, FileName)
    local insert_position = #opts.statusline + 1 -- 默认插入到末尾
    for i, component in ipairs(opts.statusline) do
      if component.provider == "%=" then
        insert_position = i
        break
      end
    end
    table.insert(opts.statusline, insert_position, FileNameBlock)

    local Clock = {
      provider = function() return os.date "🕑%H:%M" end,
      update = function()
        return true -- 总是更新
      end,
    }

    table.insert(opts.statusline, Clock)

    -- 禁用符号面包屑
    opts.winbar = nil
    -- 禁用 折叠 指示器
    vim.opt.foldcolumn = "0"

    return opts
  end,
}
