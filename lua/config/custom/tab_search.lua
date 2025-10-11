vim.api.nvim_create_user_command("TabSearch", function(opts)
  local search_str = opts.args
  if search_str == "" then
    print("Usage: :TabSearch <pattern>")
    return
  end

  local wins = vim.api.nvim_tabpage_list_wins(0) -- current tab
  local searched_bufs = {}
  local qf_items = {}

  for _, win in ipairs(wins) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    if not searched_bufs[bufnr] then
      searched_bufs[bufnr] = true
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      for i, line in ipairs(lines) do
        local start_pos, _ = line:find(search_str, 1, true)
        if start_pos then
          table.insert(qf_items, {
            bufnr = bufnr,
            lnum = i,
            col = start_pos,
            text = line,
          })
        end
      end
    end
  end

  if #qf_items == 0 then
    print("No matches found in this tab.")
    return
  end

  -- Populate the quickfix list and open it
  vim.fn.setqflist(qf_items, "r")
  vim.cmd("copen")
end, {
  nargs = 1,
  complete = "file"
})
