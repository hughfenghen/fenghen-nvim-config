-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

-- 查找所有命令（类似 VSCode Cmd+Shift+P）
-- vim.keymap.set("n", "<leader>pc", "<cmd>Telescope commands<CR>", { desc = "Commands" })

-- 查找所有 keymaps（快捷键）
-- vim.keymap.set("n", "<leader>pk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })

vim.o.autowriteall = true
-- vim.api.nvim_set_option_value("colorcolumn", "100", {})
-- vim.api.nvim_set_option_value("textwidth", 80, {})

-- vim.api.nvim_set_keymap("n", "<S-Tab>", ":bprev<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<Enter>", "o<Esc>", { noremap = true, silent = true, desc = "插入新行" })
vim.keymap.set("n", "<S-Enter>", "i<Enter><Esc>", { noremap = true, silent = true, desc = "从当前光标断行" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
-- 窗口切换：cmd + h/j/k/l
vim.keymap.set("n", "eh", "<C-w>h", { desc = "切换到左边窗口" })
vim.keymap.set("n", "el", "<C-w>l", { desc = "切换到右边窗口" })
vim.keymap.set("n", "ej", "<C-w>j", { desc = "切换到下边窗口" })
vim.keymap.set("n", "ek", "<C-w>k", { desc = "切换到上边窗口" })

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- 确保安装这些 LSP 服务器
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "lua_ls", -- Lua
        "pyright", -- Python
        "tsserver", -- TypeScript/JavaScript
        "html", -- HTML
        "cssls", -- CSS
        "jsonls", -- JSON
        "bashls", -- Bash
      })
    end,
  },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
}
