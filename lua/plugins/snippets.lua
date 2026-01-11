-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    require("luasnip").filetype_extend("typescript", { "javascript" })
    require("luasnip").filetype_extend("typescriptreact", { "javascript" })
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
