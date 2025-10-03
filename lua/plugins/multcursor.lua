return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  event = "VeryLazy",
  config = function()
    local mc = require "multicursor-nvim"
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "在上方添加光标" })
    set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "在下方添加光标" })
    set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "跳过上方添加光标" })
    set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "跳过下方添加光标" })

    -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "在下一个匹配处添加光标" })
    set({ "n", "x" }, "<C-s>", function() mc.matchSkipCursor(1) end, { desc = "跳过下一个匹配" })
    set({ "n", "x" }, "<C-m>", function() mc.matchSkipCursor(-1) end, { desc = "跳过上一个匹配" })
    -- set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end, { desc = "跳过上一个匹配" })

    -- Add and remove cursors with control + left click.
    set("n", "<c-leftmouse>", mc.handleMouse, { desc = "在鼠标位置添加光标" })
    set("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "拖拽添加光标" })
    set("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "释放鼠标选择" })

    -- Disable and enable cursors.
    set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "切换多光标模式" })
    set("x", "I", mc.insertVisual, { desc = "在所有光标处插入" })
    set("x", "A", mc.appendVisual, { desc = "在所有光标处追加" })

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ "n", "x" }, "<left>", mc.prevCursor)
      layerSet({ "n", "x" }, "<right>", mc.nextCursor)

      -- Delete the main cursor.
      layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
