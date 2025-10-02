return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  -- ebabled = false,
  config = function(_, opts)
    require("codecompanion").setup(opts)
    -- AI 插件快捷键
    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    vim.g.codecompanion_yolo_mode = true
  end,
  opts = {
    opts = {
      -- log_level = "DEBUG", -- or "TRACE"
      log_level = "TRACE",
      language = "Chinese",
    },
    display = {
      chat = {
        window = {
          layout = "vertical", -- 垂直分割
          position = "left", -- 从左侧打开
          width = 70, -- 设置宽度为70列
        },
      },
    },
    memory = {
      default = {
        description = "Collection of common files for all projects",
        files = {
          "CLAUDE.md",
        },
        is_default = true,
      },
    },

    strategies = {
      chat = {
        -- adapter = "claude_code",
        adapter = "GLM_OPENAI",
        tools = {
          opts = {
            system_prompt = {
              enabled = true,
            },
          },
          ["insert_edit_into_file"] = {
            opts = {
              requires_approval = {
                buffer = false,
                file = false, -- 设置为 false 以允许自动文件编辑
              },
            },
          },
        },
      },
      inline = {
        adapter = "GLM_OPENAI",
      },
      command = {
        adapter = "GLM_OPENAI",
      },
    },
    adapters = {
      acp = {
        claude_code = function() return require("codecompanion.adapters").extend "claude_code" end,
      },
      http = {
        GLM_OPENAI = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              api_key = function() return os.getenv "ANTHROPIC_AUTH_TOKEN" end,
              -- url = function() return os.getenv "GLM_BASE_URL" end,
              url = "https://open.bigmodel.cn/api",
              chat_url = "/paas/v4/chat/completions",
              -- chat_url = "/api/coding/paas/v4",
              -- Error: {"timestamp":"2025-10-02T08:15:20.129+00:00","status":404,"error":"Not Found","path":"/v4/v1/chat/completions"}
            },
            schema = {
              model = {
                default = "glm-4.6",
              },
            },
          })
        end,
      },
    },
  },
}
