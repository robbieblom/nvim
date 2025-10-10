local M = {}

-- Command to create a new file with template content
function M.create_file(filename, template_lines)
  -- Create a new empty buffer (listed, not scratch)
  local buf = vim.api.nvim_create_buf(true, false)

  -- Set the buffer name to the filename
  vim.api.nvim_buf_set_name(buf, filename)

  -- Insert the template content
  if template_lines and #template_lines > 0 then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, template_lines)
  end

  -- Open the buffer in the current window
  vim.api.nvim_set_current_buf(buf)

  -- Save the buffer to disk
  vim.api.nvim_command("write")
end

-- Neovim user command: :NewFile <filename>
vim.api.nvim_create_user_command("NewFile", function(opts)
  local filename = opts.fargs[1]
  if not filename then
    print("Usage: :NewFile <filename>")
    return
  end

  -- Example template content
  local template = {
    "// This is a new file",
    "",
  }

  M.create_file(filename, template)
end, { nargs = "*" })

return M
