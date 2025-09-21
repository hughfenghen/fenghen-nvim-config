vim.o.autowriteall = true

-- 检查文件路径是否在白名单中
local function isPathInWhitelist(filepath)
  local autoSavePaths = { "**/my-space/**" }
  for _, pattern in ipairs(autoSavePaths) do
    if vim.fn.match(filepath, vim.fn.glob2regpat(pattern)) ~= -1 then return true end
  end
  return false
end

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function(ev)
    local buf = ev.buf
    local filepath = vim.api.nvim_buf_get_name(buf)

    -- 添加路径白名单检查
    if not isPathInWhitelist(filepath) then return end

    if
      vim.api.nvim_get_option_value("modified", { buf = buf })
      and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
      and not vim.api.nvim_get_option_value("readonly", { buf = buf })
    then
      vim.api.nvim_buf_call(buf, function() vim.cmd "silent! write" end)
    end
  end,
})

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})
