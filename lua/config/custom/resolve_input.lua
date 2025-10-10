local util = require('config.custom.util')

local M = {}

-- Convert buffer name to function name (_anythingQualification.ts → _fetchQualification)
local function current_file_function_name()
  local bufname = vim.api.nvim_buf_get_name(0)           -- full path
  local filename = bufname:match("^.+/(.+)$") or bufname -- strip path
  local funcname = filename:gsub("%.ts$", "")            -- remove .ts extension
  -- replace leading underscore + lowercase letters up to first capital with _fetch
  funcname = funcname:gsub("^_[a-z]+", "_fetch")
  return funcname
end

-- Generate scaffold lines
local function generate_scaffold(params)
  if #params == 0 then
    print("You must provide at least one parameter")
    return {}
  end

  local resolved = params[1] -- first parameter is resolved value
  local funcname = current_file_function_name()
  local lines = {}

  -- Construct the if check for all inputs
  local if_condition = {}
  for _, p in ipairs(params) do
    table.insert(if_condition, "!" .. p)
  end
  table.insert(lines, "if (" .. table.concat(if_condition, " && ") .. ") {")
  table.insert(lines, '  throw new Error("Either ' .. table.concat(params, " or ") .. ' must be provided.");')
  table.insert(lines, "}")
  lines[#lines + 1] = "" -- blank line

  -- Initialize resolved value
  table.insert(lines, "let resolved" .. util.capitalize(resolved) .. " = " .. resolved .. ";")
  lines[#lines + 1] = "" -- blank line

  -- Conditional assignments
  for i = 2, #params do
    local keyword = (i == 2) and "if" or "else if"
    table.insert(lines, keyword .. " (!resolved" .. util.capitalize(resolved) .. " && " .. params[i] .. ") {")
    table.insert(lines,
      "  ({ id: resolved" ..
      util.capitalize(resolved) .. " } = await ussbe." .. funcname .. "({ " .. params[i] .. ": " .. params[i] .. " }));")
    table.insert(lines, "}")
  end

  return lines
end

-- Neovim command
vim.api.nvim_create_user_command("ResolveInput", function(opts)
  local params = opts.fargs
  if #params == 0 then
    print("Usage: :QualificationScaffold <resolvedValue> <otherParam1> <otherParam2> ...")
    return
  end

  local lines = generate_scaffold(params)
  if #lines > 0 then
    vim.api.nvim_put(lines, "l", true, true)
  end
end, { nargs = "*" })

return M
