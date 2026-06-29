return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      palette = "solarized",
      variant = "winter",
      transparent = {
        enabled = false,
      },
    },
    config = function(_, opts)
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      require("solarized").setup(opts)
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 900,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 800,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.opt.termguicolors = true
        vim.opt.background = "dark"
        local ok = pcall(vim.cmd.colorscheme, "solarized")
        if not ok then
          vim.cmd.colorscheme("catppuccin")
        end
      end,
    },
  },
}
