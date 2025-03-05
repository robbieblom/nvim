return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.tex_flavor = 'latex'          -- Default tex file format
    vim.g.vimtex_view_method = 'skim'   -- Choose which program to use to view PDF file
    vim.g.vimtex_view_skim_sync = 1     -- Value 1 allows forward search after every successful compilation
    vim.g.vimtex_view_skim_activate = 1 -- Value 1 allows change focus to skim after command `:VimtexView` is given
    vim.g.vimtex_quickfix_open_on_warning = 0
  end
}
