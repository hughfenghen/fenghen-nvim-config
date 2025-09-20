-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        "html-lsp",
        "ast-grep",
        "bash-language-server",
        "lua-language-server",
        "marksman",
        "stylua",
        "tailwindcss-language-server",
        "tree-sitter-cli",
        "typescript-language-server",
        "css-lsp",
      },
    },
  },
}
