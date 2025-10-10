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

    vim.g.copilot_workspace_folders = {
      "/Users/robertblom/Documents/4. Projects/2. BTI-dev/web-apps/bytetheory-innovations-website/src/frontend"
    }
  end,
}
