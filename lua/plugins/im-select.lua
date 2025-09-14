return {
  "keaising/im-select.nvim",
  config = function()
    require("im_select").setup {
      set_default_events = { "InsertLeave", "CmdlineLeave", "FocusGained" },
      set_previous_events = { "InsertEnter", "FocusLost" },
    }
  end,
}
