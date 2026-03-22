return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    -- NeoCodeium 状态组件
    local function neocodeium_status()
      local ok, neocodeium = pcall(require, "neocodeium")
      if not ok then return "" end

      local symbols = {
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
      }

      local status, server_status = neocodeium.get_status()
      return symbols.status[status] .. symbols.server_status[server_status]
    end

    -- 文件路径组件
    -- local function filename_with_path()
    --   local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    --   if filename == "" then return "[No Name]" end
    --
    --   -- 如果路径太长，缩短显示
    --   local max_length = math.floor(vim.o.columns * 0.25)
    --   if #filename > max_length then filename = vim.fn.pathshorten(filename, 3) end
    --
    --   if vim.bo.modified then filename = filename .. " *" end
    --   return filename
    -- end

    -- 时钟组件
    local function clock() return os.date "🕑%H:%M" end

    local function search_cnt()
      if vim.v.hlsearch == 0 then return "" end

      local _, res = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 1000 })

      if res.total > 0 then return string.format("🔍[%d/%d]", res.current, res.total) end

      return "🔍[?/?]"
    end

    return {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        refresh = {
          statusline = 1000, -- 每秒更新一次以显示时钟
        },
        disabled_filetypes = {
          winbar = { "*" }, -- 对所有文件类型禁用 winbar
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          "%=",
          -- {
          --   filename_with_path,
          --   color = function()
          --     local utils = require "lualine.utils.utils"
          --     return { fg = utils.extract_highlight_colors("Directory", "fg") }
          --   end,
          -- },
          { search_cnt, type = "lua_expr" },
        },
        lualine_x = {
          "lsp_status",
          "encoding",
          -- "filetype",
        },
        lualine_y = {
          "location",
          -- "progress",
          {
            neocodeium_status,
            color = { fg = "yellow" },
          },
          {
            clock,
            color = { fg = "gray" },
          },
        },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {},
      inactive_winbar = {},
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)

    -- 禁用折叠指示器（对应您的 vim.opt.foldcolumn = "0"）
    vim.opt.foldcolumn = "0"
    vim.o.statuscolumn = ""
  end,
}
