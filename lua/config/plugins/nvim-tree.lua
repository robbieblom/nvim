vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- change color for arrows in tree to light blue
-- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#000000 ]])

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = { enable = true },
      renderer            = {
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      filters             = {
        git_ignored = false,
        dotfiles = true,
      },
    })
    vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>") -- toggle file explorer
  end,
}
