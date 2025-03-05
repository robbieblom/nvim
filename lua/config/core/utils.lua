-- for github copilot
-- local function SuggestOneCharacter()
--   local suggestion = vim.fn['copilot#Accept']("")
--   local bar = vim.fn['copilot#TextQueuedForInsertion']()
--   return bar:sub(1, 1)
-- end
--
-- local function SuggestOneWord()
--   local suggestion = vim.fn['copilot#Accept']("")
--   local bar = vim.fn['copilot#TextQueuedForInsertion']()
--   return vim.fn.split(bar, [[[ .]\zs]])[1]
-- end
--
-- local map = vim.keymap.set
-- map('i', '<C-l>', SuggestOneCharacter, { expr = true, remap = false })
-- map('i', '<C-g>', SuggestOneWord, { expr = true, remap = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rst",
  callback = function()
    vim.opt_local.tabstop = 3
    vim.opt_local.shiftwidth = 3
    vim.opt_local.expandtab = true
  end,
})
