---@module 'snacks.meta.types'

vim.keymap.set("n", "<C-I>", "<C-I>", { desc = "Jump forward in jumplist" })
vim.keymap.set("n", "<C-O>", "<C-O>", { desc = "Jump backward in jumplist" })

-- 合并 buflines 跟 search 的效果
vim.keymap.set("n", "/", function()
  Snacks.picker.lines {
    matcher = { fuzzy = false },
    on_close = function(picker)
      local input_text = picker.input:get()
      -- picker 关闭时，将搜索文本设置到 Vim 的搜索寄存器
      if input_text and input_text ~= "" then
        vim.fn.setreg("/", input_text)
        vim.o.hlsearch = true
      end
    end,
  }
end, { desc = "Buffer Lines" })

local function feedkeys(keys)
  local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(termcodes, "n", false)
end

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

-- vim.api.nvim_set_keymap("n", "<S-Tab>", ":bprev<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true })
-- Tab 显示 buffer 列表
vim.keymap.set("n", "<Tab>", function()
  Snacks.picker.buffers {
    sort_lastused = true,
    current = false,
    prompt = "Switch Buffer",
    jump = {
      match = false, -- 禁用匹配位置跳转
      frecency = true,
    },
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

return {}
