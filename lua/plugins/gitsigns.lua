return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  opts = function(_, opts)
    local old_on_attach = opts.on_attach
    opts.on_attach = function(bufnr)
      if old_on_attach then old_on_attach(bufnr) end
      vim.keymap.del("n", "<Leader>gd", { buffer = bufnr })
    end
    return opts
  end,
}
