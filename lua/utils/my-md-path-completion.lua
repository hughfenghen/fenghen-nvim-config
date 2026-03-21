--- @class blink.cmp.Source
local source = {}

local function list_files(cwd)
  local result = vim.system({ "git", "-C", cwd, "ls-files", "-co", "--exclude-standard" }):wait()
  local files = {}

  if result.code == 0 and result.stdout then
    for path in result.stdout:gmatch "[^\r\n]+" do
      if path ~= "" then table.insert(files, path) end
    end
  else
    for _, file in ipairs(vim.fn.glob(cwd .. "/**/*", false, true)) do
      if vim.fn.isdirectory(file) == 0 then
        local rel_path = vim.fn.fnamemodify(file, ":.")
        if not rel_path:match "^%.git/" then table.insert(files, rel_path) end
      end
    end
  end

  return files
end

local function list_buffer_files()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  local files = {}
  local seen = {}

  table.sort(buffers, function(a, b) return (a.lastused or 0) > (b.lastused or 0) end)

  for _, buf in ipairs(buffers) do
    local name = buf.name
    if name and name ~= "" and vim.fn.filereadable(name) == 1 then
      local rel_path = vim.fn.fnamemodify(name, ":.")
      if not rel_path:match "^%.git/" and not seen[rel_path] then
        seen[rel_path] = true
        table.insert(files, rel_path)
      end
    end
  end

  return files
end

local function get_replace_start_col()
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, cursor_col)
  local at_pos, query = before_cursor:match ".*()@([^%s]*)$"

  if not at_pos then return nil, nil end

  return at_pos, query
end

local function fuzzy_score(text, query)
  if query == "" then return 0 end

  local t = text:lower()
  local q = query:lower()
  local qi = 1
  local score = 0
  local last_match = 0

  for i = 1, #t do
    if t:sub(i, i) == q:sub(qi, qi) then
      if last_match > 0 then
        score = score + (i - last_match - 1)
      else
        score = score + (i - 1)
      end
      last_match = i
      qi = qi + 1
      if qi > #q then return score end
    end
  end

  return nil
end

local function filter_and_sort_files(files, query)
  local matched = {}

  for _, rel_path in ipairs(files) do
    local s = fuzzy_score(rel_path, query)
    if s ~= nil then table.insert(matched, { path = rel_path, score = s }) end
  end

  table.sort(matched, function(a, b)
    if a.score ~= b.score then return a.score < b.score end
    if #a.path ~= #b.path then return #a.path < #b.path end
    return a.path < b.path
  end)

  return matched
end

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

function source:enabled() return vim.bo.filetype == "markdown" end

function source:get_trigger_characters() return { "@" } end

function source:get_completions(_, callback)
  local at_pos, query = get_replace_start_col()
  if not at_pos then
    callback {
      items = {},
      is_incomplete_forward = false,
      is_incomplete_backward = false,
    }
    return function() end
  end

  local cwd = vim.fn.getcwd()
  local matched = {}
  local is_incomplete_forward = false

  if query == "" then
    is_incomplete_forward = true
    for _, rel_path in ipairs(list_buffer_files()) do
      table.insert(matched, { path = rel_path, score = 0 })
    end
  else
    local files = list_files(cwd)
    matched = filter_and_sort_files(files, query)
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1
  local start_col = at_pos - 1
  local end_col = cursor[2]
  local file_kind = require("blink.cmp.types").CompletionItemKind.File

  local items = {}
  for _, item in ipairs(matched) do
    local rel_path = item.path
    local final_text = "@" .. rel_path
    table.insert(items, {
      label = final_text,
      kind = file_kind,
      insertText = final_text,
      textEdit = {
        newText = final_text,
        range = {
          start = { line = line, character = start_col },
          ["end"] = { line = line, character = end_col },
        },
      },
    })
  end

  callback {
    items = items,
    is_incomplete_forward = is_incomplete_forward,
    is_incomplete_backward = false,
  }

  return function() end
end

return source
