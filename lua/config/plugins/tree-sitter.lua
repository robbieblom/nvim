return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "lua",
        "javascript",
        "html",
        'bash',
        'css',
        'csv',
        'dockerfile',
        'gitignore',
        'json',
        'make',
        'python',
        'sql',
        'typescript',
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
      auto_tag = { enable = true }
    })
  end
}
