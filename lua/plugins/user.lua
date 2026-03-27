-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE

-- vim.env.http_proxy = "http://127.0.0.1:1199"
-- vim.env.https_proxy = "http://127.0.0.1:1199"
-- vim.env.all_proxy = "socks5://127.0.0.1:1199"
-- vim.env.HTTP_PROXY = "http://127.0.0.1:1199"
-- vim.env.HTTPS_PROXY = "http://127.0.0.1:1199"
-- vim.env.ALL_PROXY = "socks5://127.0.0.1:1199"

---@type LazySpec
return {
  -- == Examples of Adding Plugins ==
  { "stevearc/aerial.nvim", enabled = false },
  { "ray-x/lsp_signature.nvim", enabled = false, event = "BufRead" },
  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "rebelot/heirline.nvim", enabled = false },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      npairs.setup {}

      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("“", "”"):use_multibyte(),
          Rule("‘", "’"):use_multibyte(),
          -- 以下规则光标位置错误
          -- Rule("【", "】"):use_multibyte():use_key "【",
          -- Rule("（", "）"):use_multibyte():use_key "（",
          -- Rule("「", "」"):use_multibyte():use_key "「",
          -- Rule("《", "》"):use_multibyte():use_key "《",

          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is % “”
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
}
