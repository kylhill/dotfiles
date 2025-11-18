return {
  -- Pin version to v14 since Ubuntu 25.10 does not include Neovim >= 0.11.2
  { "folke/lazy.nvim", version = "v14" },
  { "LazyVim/LazyVim", version = "v14" },

  -- Disable luarocks support to avoid system dependency
  {
    "LazyVim/LazyVim",
    opts = {
      rocks = {
        enabled = false,
      },
    },
  },
}
