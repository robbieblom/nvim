-- return {
--   "zbirenbaum/copilot.lua",
--   cmd = "Copilot",
--   event = "InsertEnter",
--   config = function()
--     require("copilot").setup({
--       suggestion = {
--         auto_trigger = true,
--         keymap = {
--           accept = "<M-Down>",
--           accept_word = "<M-Right>",
--           dismiss = "<M-Left>",
--         }
--       }
--     })
--   end,
-- }
return {
  "github/copilot.vim",
  config = function()
    vim.keymap.set('i', '<M-Down>', 'copilot#Accept("")', {
      expr = true,
      replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true

    vim.keymap.set('i', '<M-Right>', 'copilot#AcceptWord("")', {
      expr = true,
      replace_keycodes = false
    })
  end,
}
