return {
  'norcalli/nvim-colorizer.lua',
  enabled = true,
  config = function()
    vim.opt.termguicolors = true
    require('colorizer').setup({
      '*',
      css = { css = true, css_fn = true },
    })
  end,
}
