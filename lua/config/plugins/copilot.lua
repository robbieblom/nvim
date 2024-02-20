return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<M-Down>",
          accept_word = "<M-Right>",
          dismiss = "<M-Left>",
        }
      }
    })
  end,
}
