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

    -- 2. 把默认 winbar 禁用
    opts.winbar = nil
    -- 禁用 折叠 指示器
    vim.opt.foldcolumn = "0"

    -- 3. 把 NeoCodeium 组件加到 statusline 右侧
    table.insert(opts.statusline, NeoCodeium)

    return opts
  end,
}
