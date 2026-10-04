return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      require("solarized").setup(opts)
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },

  { "folke/tokyonight.nvim", enabled = false },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.opt.termguicolors = true
        vim.opt.background = "dark"
        local ok = pcall(vim.cmd.colorscheme, "solarized")
        if not ok then
          ok = pcall(vim.cmd.colorscheme, "catppuccin")
        end
        if not ok then
          vim.cmd.colorscheme("habamax")
        end
      end,
    },
  },
}
