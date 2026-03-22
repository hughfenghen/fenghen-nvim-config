-- if true then return {} end

return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },
  event = "InsertEnter",
  -- use a release tag to download pre-built binaries
  version = "1.*",
  -- AND/OR build from source
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = "default" },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    snippets = { preset = "default" },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        markdown = {
          "git_files_path",
          "path",
          "lsp",
          "snippets",
          "buffer",
        },
      },
      providers = {
        git_files_path = {
          name = "Custom Files",
          module = "utils.my-md-path-completion", -- 指向刚创建的模块
          enabled = function() return vim.bo.filetype == "markdown" end,
          score_offset = 120,
        },
        snippets = {
          opts = {
            friendly_snippets = true, -- default

            -- see the list of frameworks in: https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks
            -- and search for possible languages in: https://github.com/rafamadriz/friendly-snippets/blob/main/package.json
            -- the following is just an example, you should only enable the frameworks that you use
            extended_filetypes = {
              typescript = { "javascript" },
              typescriptreact = { "javascript" },
              -- sh = { "shelldoc" },
              -- markdown = { "jekyll" },
              -- php = { "phpdoc" },
              -- cpp = { "unreal" },
            },
          },
        },
      },
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true }, ghost_text = { enabled = true } },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
