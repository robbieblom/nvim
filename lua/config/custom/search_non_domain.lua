local util = require('config.custom.util')

-- Helper to build the find command
local function build_find_command(base_dirs, exclude_dirs, extensions)
  local cmd = { "find" }
  for _, d in ipairs(base_dirs) do
    table.insert(cmd, d)
  end
  table.insert(cmd, "-type f")

  -- File extensions
  local ext_pattern = {}
  for _, ext in ipairs(extensions) do
    table.insert(ext_pattern, " -name '*." .. ext .. "'")
  end
  table.insert(cmd, "\\(" .. table.concat(ext_pattern, " -o ") .. " \\)")

  -- Exclude directories
  for _, ex in ipairs(exclude_dirs) do
    table.insert(cmd, "-not -path '" .. ex .. "/*'")
  end

  -- Return command as string
  return table.concat(cmd, " ")
end

-- Main function: search string across codebase
local function search_codebase(search_str, base_dirs)
  base_dirs = base_dirs or { "./src", "./tests" }
  local extensions = { "ts", "sql" }

  local find_cmd = build_find_command(base_dirs, util.domain_directories, extensions)
  print(find_cmd) -- Debug: print the find command being executed
  local files = vim.fn.split(vim.fn.system(find_cmd), "\n")

  local qf_items = {}

  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      local lines = vim.fn.readfile(file)
      for lineno, line in ipairs(lines) do
        local col = line:find(search_str, 1, true)
        if col then
          table.insert(qf_items, {
            filename = file,
            lnum = lineno,
            col = col,
            text = line,
          })
        end
      end
    end
  end

  if #qf_items == 0 then
    print("No matches found for:", search_str)
    return
  end

  -- Populate quickfix and open
  vim.fn.setqflist(qf_items, "r")
  vim.cmd("copen")
end

-- Expose as a user command
vim.api.nvim_create_user_command("SearchNonDomain", function(opts)
  local search_str = opts.args
  if not search_str or search_str == "" then
    print("Usage: :SearchNonDomain <pattern>")
    return
  end
  search_codebase(search_str)
end, { nargs = 1 })
