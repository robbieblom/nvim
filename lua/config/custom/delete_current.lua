vim.api.nvim_create_user_command("Dfi", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Delete file from disk
  os.remove(filepath)

  -- Wipe out buffer
  vim.api.nvim_buf_delete(bufnr, { force = true })
end, {})


vim.api.nvim_create_user_command("Dff", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Get folder containing the file
  local folder = vim.fn.fnamemodify(filepath, ":h")

  -- Delete the folder and all its contents
  -- Use 'rm -rf' on Unix/macOS, adjust for Windows if needed
  os.execute("rm -rf " .. vim.fn.shellescape(folder))

  -- Wipe out buffer
  vim.api.nvim_buf_delete(bufnr, { force = true })
end, {})
