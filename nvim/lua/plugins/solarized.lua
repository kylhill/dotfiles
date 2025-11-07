return {
  {
    "maxmx03/solarized.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("solarized")
    end,
    lazy = false,
  },
}
