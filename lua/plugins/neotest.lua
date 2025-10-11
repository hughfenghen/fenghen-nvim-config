return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local function contains_vitest_import(file_path)
      local f = io.open(file_path, "r")
      if not f then return false end
      for line in f:lines() do
        if line:find "import%.meta%.vitest" then
          f:close()
          return true
        end
      end
      f:close()
      return false
    end

    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup {
      adapters = {
        require "neotest-vitest" {
          vitestCommand = "pnpm vitest",
          cwd = function(testFilePath) return vim.fs.root(testFilePath, "node_modules") end,

          filter_dir = function(name) return name ~= "node_modules" end,

          is_test_file = function(file_path)
            -- 忽略文件夹
            if vim.fn.isdirectory(file_path) == 1 then return false end

            -- 默认逻辑: 只认 .test. / .spec.
            if file_path:match "%.test%.tsx?$" or file_path:match "%.spec%.tsx?$" then return true end
            -- 扩展: 允许普通源码文件也包含测试
            if file_path:match "%.d%.ts$" then return false end -- 忽略 d.ts
            if file_path:match ".+/src/.+%.tsx?$" and contains_vitest_import(file_path) then return true end

            return false
          end,
        },
      },
      ---@diagnostic disable-next-line: missing-fields
      summary = {
        ---@diagnostic disable-next-line: missing-fields
        mappings = { expand_all = "<S-Enter>" },
      },
    }
    -- 打开测试摘要窗口
    vim.keymap.set(
      "n",
      "<leader>ts",
      function() require("neotest").summary.toggle() end,
      { desc = "Toggle test summary" }
    )

    -- 打开测试输出
    vim.keymap.set(
      "n",
      "<leader>to",
      function() require("neotest").output.open { enter = true } end,
      { desc = "Open test output" }
    )

    vim.keymap.set("n", "<leader>tw", function() require("neotest").watch.toggle() end, { desc = "Toggle watch" })

    -- 停止测试
    vim.keymap.set("n", "<leader>tS", function() require("neotest").run.stop() end, { desc = "Stop test" })

    -- vim.keymap.set("n", "<leader>tt", ":Neotest run last<CR>", { desc = "Run last test" })
    -- vim.keymap.set("n", "<leader>tn", ":Neotest run<CR>", { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", ":Neotest run file<CR>", { desc = "Run current file" })
  end,
}
