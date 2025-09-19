-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

-- 查找所有命令（类似 VSCode Cmd+Shift+P）
-- vim.keymap.set("n", "<leader>pc", "<cmd>Telescope commands<CR>", { desc = "Commands" })

-- 查找所有 keymaps（快捷键）
-- vim.keymap.set("n", "<leader>pk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })

vim.o.autowriteall = true
vim.opt.autoread = true

local function feedkeys(keys)
  local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(termcodes, "n", false)
end

-- vim.api.nvim_set_option_value("colorcolumn", "100", {})
-- vim.api.nvim_set_option_value("textwidth", 80, {})

-- vim.api.nvim_set_keymap("n", "<S-Tab>", ":bprev<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true })
-- Tab 显示 buffer 列表
vim.keymap.set("n", "<Tab>", function()
  Snacks.picker.buffers {
    sort_lastused = true, -- 修正：使用正确的配置项名称
    current = false, -- 修正：使用 current = false 来忽略当前缓冲区
    prompt = "Switch Buffer",
    win = {
      input = {
        keys = {
          ["<Tab>"] = { "list_down", mode = { "n", "i" } },
          ["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
        },
      },
    },
    format = function(item, picker)
      local ret = {}
      -- Column 1: Buffer ID (Orange)
      ret[#ret + 1] = { string.format("%-4s", tostring(item.buf)), "WarningMsg" }

      local path = Snacks.picker.util.path(item) or item.file
      path = Snacks.picker.util.truncpath(path, picker.opts.formatters.file.truncate or 40, { cwd = picker:cwd() })
      local name, cat = path, "file"
      if item.buf and vim.api.nvim_buf_is_loaded(item.buf) then
        name = vim.bo[item.buf].filetype
        cat = "filetype"
      elseif item.dir then
        cat = "directory"
      end

      if picker.opts.icons.files.enabled ~= false then
        local icon, hl = Snacks.util.icon(name, cat, {
          fallback = picker.opts.icons.files,
        })
        if item.dir and item.open then icon = picker.opts.icons.files.dir_open end
        icon = Snacks.picker.util.align(icon, picker.opts.formatters.file.icon_width or 2)
        ret[#ret + 1] = { icon, hl, virtual = true }
      end

      local filepath = item.file or ""
      local filename = vim.fn.fnamemodify(filepath, ":t")

      ret[#ret + 1] = { filename, "SnacksPickerFile" }

      -- 尝试获取 git root 路径和项目信息
      local git_root = ""
      local project_name = ""

      if item.info and item.info.variables and item.info.variables.gitsigns_status_dict then
        git_root = item.info.variables.gitsigns_status_dict.root or ""
        if git_root ~= "" then
          -- 提取项目名称（git root 的最后一个目录名）
          project_name = vim.fn.fnamemodify(git_root, ":t")
        end
      end

      local display_path = ""

      if git_root ~= "" then
        -- 显示 项目名/相对路径
        local relative_path = filepath:gsub("^" .. vim.pesc(git_root) .. "/", "")
        local relative_dir = vim.fn.fnamemodify(relative_path, ":h")

        if relative_dir == "." then
          display_path = project_name
        else
          display_path = project_name .. "/" .. relative_dir
        end
      else
        -- 没有 git root，显示相对路径
        display_path = vim.fn.fnamemodify(filepath, ":~:.:h")
        if display_path == "." then display_path = "" end
      end

      -- 设置文件名的固定宽度
      if display_path ~= "" then
        ret[#ret + 1] = { "    ", "None" } -- Separator
        ret[#ret + 1] = { display_path, "SnacksPickerComment" }
      end

      return ret
    end,
  }
end, { desc = "Switch buffers" })

vim.keymap.set("n", "<Enter>", function()
  if vim.bo.modifiable and not vim.bo.readonly then
    feedkeys "o<Esc>"
  else
    feedkeys "<Enter>"
  end
end, { noremap = true, silent = true, desc = "插入新行" })

vim.keymap.set("n", "<S-Enter>", function()
  if vim.bo.modifiable and not vim.bo.readonly then
    feedkeys "i<Enter><Esc>"
  else
    feedkeys "<S-Enter>"
  end
end, { noremap = true, silent = true, desc = "从当前光标断行" })
-- vim.keymap.set("n", "<S-Enter>", "i<Enter><Esc>", { noremap = true, silent = true, desc = "从当前光标断行" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
-- 窗口切换：cmd + h/j/k/l
vim.keymap.set("n", "eh", "<C-w>h", { desc = "切换到左边窗口" })
vim.keymap.set("n", "el", "<C-w>l", { desc = "切换到右边窗口" })
vim.keymap.set("n", "ej", "<C-w>j", { desc = "切换到下边窗口" })
vim.keymap.set("n", "ek", "<C-w>k", { desc = "切换到上边窗口" })
vim.keymap.set("n", "<Space>bn", ":bnext<CR>", { noremap = true, silent = true })

require("luasnip").filetype_extend("typescript", { "javascript" })
require("luasnip.loaders.from_vscode").lazy_load()

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
