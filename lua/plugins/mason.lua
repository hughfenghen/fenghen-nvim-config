-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsUninstall" },
    enabled = false,
    -- event = "User AstroFile",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      start_delay = 3000,
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        "html-lsp",
        "ast-grep",
        "bash-language-server",
        "lua-language-server",
        "marksman",
        "stylua",
        -- "tailwindcss-language-server",
        "tree-sitter-cli",
        "typescript-language-server",
        "css-lsp",
      },
    },
  },
}
