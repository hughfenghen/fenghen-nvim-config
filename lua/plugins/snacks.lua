---@module 'snacks.meta.types'
-- luacheck: globals vim

local filePickerTransform = {
  format = "file", -- 使用默认的 file formatter
  transform = function(item)
    item.line = nil -- 移除代码行
    return item
  end,
}

local function file_no_code(item, picker)
  local ret = {}

  if item.label then
    ret[#ret + 1] = { item.label, "SnacksPickerLabel" }
    ret[#ret + 1] = { " ", virtual = true }
  end

  if item.parent then vim.list_extend(ret, Snacks.picker.format.tree(item, picker)) end

  if item.status then vim.list_extend(ret, Snacks.picker.format.file_git_status(item, picker)) end

  if item.severity then vim.list_extend(ret, Snacks.picker.format.severity(item, picker)) end

  -- 只显示文件名/路径，不显示代码
  vim.list_extend(ret, Snacks.picker.format.filename(item, picker))

  return ret
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  -- lazy = true,
  event = "VeryLazy",
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      previewers = {
        diff = {
          builtin = false,
          style = "terminal",
        },
      },
      win = {
        input = {
          keys = {
            ["<c-a>"] = false, -- 禁用输入窗口中的 Ctrl+A
            -- ["<c-c>"] = "close", -- 将 <c-c> 改为关闭窗口
          },
        },
      },
      sources = {
        -- 列表中移除代码，避免干扰
        lsp_definitions = filePickerTransform,
        lsp_references = filePickerTransform,
        lsp_implementations = filePickerTransform,
        grep = { format = file_no_code },
        explorer = {
          layout = {
            layout = {
              position = "float",
              -- position = "right", -- <-- 把 "left" 改成 "bottom" / "right" 以改变开的位置
            },
          },
          auto_close = true,
          win = {
            list = {
              keys = {
                ["<c-c>"] = "close", -- 将 <c-c> 改为关闭窗口
              },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
      snacks_image = {
        relative = "cursor",
        border = "rounded",
        focusable = false,
        backdrop = false,
        row = 1,
        col = 1,
        zindex = 1,
      },
    },
    image = { enabled = true },
    win = {
      wo = {
        wrap = true,
        linebreak = true, -- 在单词边界换行，更美观
      },
    },
    zen = {
      win = {
        height = function()
          return vim.o.lines -- 使用整个屏幕高度
        end,
        row = 0, -- 从屏幕顶部开始
      },
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = true, -- 默认启用诊断信息
        inlay_hints = true, -- 如果需要 LSP inlay hints
      },

      on_open = function(win)
        -- 移除自动退出的 autocmd
        vim.api.nvim_clear_autocmds {
          group = win.augroup,
          event = "WinEnter",
        }

        -- 初始设置
        vim.wo.number = true
        vim.wo.relativenumber = true

        -- 监听 buffer 切换事件
        vim.api.nvim_create_autocmd("BufWinEnter", {
          group = win.augroup,
          callback = function()
            if win:win_valid() then
              vim.wo[win.win].number = true
              vim.wo[win.win].relativenumber = true
            end
          end,
        })
      end,
    },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      "<leader><space>",
      function()
        local frecency = require("snacks.picker.core.frecency").new()
        Snacks.picker.smart {
          matcher = {
            frecency = false,
            cwd_bonus = false,
            sort_empty = true,
          },
          sort = function(a, b)
            local a_score = a.score or 0
            local b_score = b.score or 0
            if a_score ~= b_score then return a_score > b_score end

            local function get_lastused(item)
              if item.info and item.info.lastused then return item.info.lastused end
              return 0
            end

            local function get_hotness(item)
              if item.frecency == nil then item.frecency = frecency:get(item) end
              return item.frecency
            end

            local a_time = get_lastused(a)
            local b_time = get_lastused(b)
            if a_time ~= b_time then return a_time > b_time end

            local a_hot = get_hotness(a)
            local b_hot = get_hotness(b)
            if a_hot ~= b_hot then return a_hot > b_hot end

            return (a.idx or 0) < (b.idx or 0)
          end,
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
            local path = Snacks.picker.util.path(item) or item.file
            path = Snacks.picker.util.truncpath(
              path,
              tonumber(picker.opts.formatters.file.truncate) or 40,
              { cwd = picker:cwd() }
            )
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
              ret[#ret + 1] = { "  ", "None" } -- Separator
              ret[#ret + 1] = { display_path, "SnacksPickerComment" }
            end

            return ret
          end,
          filter = { cwd = true },
        }
      end,
      desc = "Smart Find Files",
    },
    -- { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },

    -- find
    -- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- { "<leader>fc", function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end, desc = "Find Config File" },
    -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    -- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    -- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    -- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    -- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    -- { "<leader>sg", function() Snacks.picker.grep { regex = false } end, desc = "Grep" },
    { "<C-g>", function() Snacks.picker.grep { regex = false } end, desc = "Grep" },
    -- { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    -- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history {
          confirm = function(picker, item)
            picker:close()
            if item then
              vim.fn.setreg("/", item.text)
              vim.o.hlsearch = true
            end
          end,
        }
      end,
      desc = "Search History",
    },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks {
          global = true,
          ["local"] = true,
          transform = function(item) return item.label and item.label:match "[a-zA-Z]" and item or false end,
        }
      end,
      desc = "Marks (Manual Only)",
    },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- 显示所有符号类型
    {
      "<leader>ss",
      function() Snacks.picker.lsp_symbols { filter = { [vim.bo.filetype] = true } } end,
      desc = "LSP Symbols",
    },
    -- 显示所有符号类型
    {
      "<leader>sS",
      -- function() Snacks.picker.lsp_workspace_symbols { filter = { [vim.bo.filetype] = true } } end,
      function() Snacks.picker.lsp_workspace_symbols() end,
      desc = "LSP Workspace Symbols",
    },
    -- Other
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>-", function() Snacks.scratch { ft = "markdown" } end, desc = "Toggle Scratch Buffer" },
    { "<leader>_", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    -- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    -- { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    -- { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
        Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
        Snacks.toggle.diagnostics():map "<leader>ud"
        Snacks.toggle.line_number():map "<leader>ul"
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map "<leader>uc"
        Snacks.toggle.treesitter():map "<leader>uT"
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
        Snacks.toggle.inlay_hints():map "<leader>uh"
        Snacks.toggle.indent():map "<leader>ug"
        Snacks.toggle.dim():map "<leader>uD"
      end,
    })
  end,
}
