return {
  "Bekaboo/dropbar.nvim",
  config = function()
    local utils = require "dropbar.utils"
    require("dropbar").setup {
      icons = {
        kinds = {
          dir_icon = function(_)
            return "", "" -- 不显示图标，也不设置高亮
          end,
        },
      },
      sources = {
        path = {
          modified = function(sym)
            return sym:merge {
              name = sym.name .. " *",
              name_hl = "DiffDelete",
            }
          end,
        },
      },
      menu = {
        keymaps = {
          -- 保留默认的 q/Esc 关闭菜单
          ["q"] = "<C-w>q",
          ["h"] = "<C-w>q",
          ["l"] = function()
            local menu = utils.menu.get_current()
            if not menu then return end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if component then menu:click_on(component, nil, 1, "l") end
          end,
          ["<CR>"] = function()
            local menu = utils.menu.get_current()
            if not menu then return end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if not component then return end
            -- 优先尝试 jump
            if component.jump then
              component:jump()
              -- 跳转后关闭所有菜单
              local root = menu:root()
              if root then root:close(false) end
              return
            end
            -- 回退：执行默认点击（可能打开子菜单或跳转）
            menu:click_on(component, nil, 1, "l")
          end,
          ["i"] = function()
            local menu = utils.menu.get_current()
            if menu then menu:fuzzy_find_open() end
          end,
        },
      },
    }

    local dropbar_api = require "dropbar.api"
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
