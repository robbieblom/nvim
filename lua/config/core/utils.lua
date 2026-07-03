local group = vim.api.nvim_create_augroup("Black", { clear = true })
vim.api.nvim_create_autocmd("bufWritePost", {
  pattern = "*.py",
  command = "silent !black %",
  group = group,
})



-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "rst",
--   callback = function()
--     vim.opt_local.tabstop = 3
--     vim.opt_local.shiftwidth = 3
--     vim.opt_local.expandtab = true
--   end,
-- })

local function tex_focus_vim()
  -- Replace TERMINAL with the name of your terminal application
  -- Example: vim.fn.system("open -a iTerm")
  -- Example: vim.fn.system("open -a Alacritty")
  vim.fn.system("open -a iTerm")
  vim.cmd("redraw!")
end

vim.api.nvim_create_augroup("vimtex_event_focus", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "vimtex_event_focus",
  pattern = "VimtexEventViewReverse",
  callback = tex_focus_vim,
})
