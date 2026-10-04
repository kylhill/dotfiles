return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = true },
      picker = { enabled = true },
      scroll = { enabled = true },
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Visual Selection or Word" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
    },
  },
  { "nvim-lualine/lualine.nvim", opts = { options = { globalstatus = true } } },
}
