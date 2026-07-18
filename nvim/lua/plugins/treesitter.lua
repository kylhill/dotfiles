return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "tree-sitter-cli" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = {
        "bash",
        "diff",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "vim",
        "vimdoc",
        "yaml",
      }
    end,
  },
}
