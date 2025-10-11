local M = {}

M.sdk_folder = "./src/app/sdk"
M.api_folder = "./src/app/api"
M.schema_folder = "./src/backend/schema/init"
M.domain_directories = {
  M.sdk_folder,
  M.api_folder,
  M.schema_folder,
}

-- Utility: capitalize first letter
local function capitalize(s)
  return s:sub(1, 1):upper() .. s:sub(2)
end
M.capitalize = capitalize

-- Convert snake_case → camelCase
local function to_camel_case(s)
  return (s:gsub("_(%l)", function(c) return c:upper() end))
end
M.to_camel_case = to_camel_case

-- Remove trailing s for folder names
local function singular(s)
  return s:gsub("s$", "")
end
M.singular = singular

-- convert PascalCase/camelCase -> snake_case
function M.to_snake_case(str)
  local s = str:gsub("([A-Z])", "_%1")
  return s:lower():gsub("^_", "")
end

function M.resolve_sdk_type(path)
  local sdk_type = path:match("^be") or path:match("^fe")

  if not sdk_type then
    print("Argument must start with 'be' or 'fe' to indicate backend or frontend.")
    return
  end

  return sdk_type
end

function M.resolve_sdk_types(path)
  local sdk_type = nil
  if path:match("^%[(.+),(.+)%]") then
    local t1, t2 = path:match("^%[(.+),(.+)%]")
    sdk_type = { t1, t2 }
    for _, t in ipairs(sdk_type) do
      if t ~= "be" and t ~= "fe" then
        error("Each type in the list must be 'be' or 'fe'.")
      end
    end
    return sdk_type
  else
    print('here')
    sdk_type = path:match("^be") or path:match("^fe")
    if not sdk_type then
      error("Argument must start with 'be' or 'fe' to indicate backend or frontend.")
    end
    return { sdk_type }
  end
end

function M.resolve_sdk_folder(path)
  local _, _, folder_name = path:find("/(.+)$")
  if not folder_name then
    print("path must be in the format 'be/qualification' or 'fe/user'.")
    return
  end
  return folder_name
end

function M.resolve_method_name(action, entity, sdk_type)
  if sdk_type == "be" then
    return "_" .. action .. capitalize(entity)
  else
    return action .. capitalize(entity)
  end
end

function M.resolve_params_type(action, entity, sdk_type)
  if sdk_type == "be" then
    return "_" .. capitalize(action) .. capitalize(entity) .. "Params"
  else
    return capitalize(action) .. capitalize(entity) .. "Params"
  end
end

function M.resolve_entity_type(entity, sdk_type)
  if sdk_type == "be" then
    return "_" .. capitalize(entity)
  else
    return capitalize(entity)
  end
end

function M.resolve_sdk_class_name(sdk_type)
  if sdk_type == "be" then
    return "USSBackendClient"
  else
    return "USSFrontendClient"
  end
end

function M.resolve_sdk_filename(operation, entity, sdk_type)
  if sdk_type == "be" then
    return "_" .. operation .. capitalize(entity) .. ".ts"
  else
    return operation .. capitalize(entity) .. ".ts"
  end
end

function M.resolve_client_path(sdk_type)
  if sdk_type == "be" then
    return "./src/app/sdk/be/client.ts"
  else
    return "./src/app/sdk/fe/client.ts"
  end
end

function M.resolve_sdk_path(path)
  local sdk_type = M.resolve_sdk_type(path)

  local _, _, sdk_path = path:find(string.format("^%s/(.+)$", sdk_type))
  if not sdk_path then
    error("path must be in the format 'be/qualification' or 'fe/user'.")
  end

  return string.format("./src/app/sdk/%s/%s", sdk_type, sdk_path)
end

function M.resolve_api_path(path)
  return "./src/app/api/" .. path:gsub("^/+", ""):gsub("/+$", "")
end

-- Search a buffer for a string
-- bufnr: buffer number (0 for current)
-- query: string or Lua pattern
-- plain: if true, disables Lua patterns (exact match)
-- returns: line (1-based), column (1-based), or nil if not found
function M.search_buffer(bufnr, query, plain, reverse)
  bufnr = bufnr or 0    -- default to current buffer
  vim.fn.bufload(bufnr) -- ensure buffer is loaded

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if reverse then
    for i = #lines, 1, -1 do
      local col = lines[i]:find(query, 1, plain)
      if col then
        return i, col
      end
    end
  else
    for i, line in ipairs(lines) do
      local col = line:find(query, 1, plain)
      if col then
        return i, col
      end
    end
  end
end

function M.find_resolved_path_of_file(filename, folders_to_search)
  local find_cmd = 'find ' .. table.concat(folders_to_search, " ") ..
      string.format(' -type f \\( -name "%s" -o -name "%s" \\) -print -quit', filename, filename)
  local handle = io.popen(find_cmd)
  if not handle then
    error("Failed to execute find command")
  end

  local result = handle:read("*a")
  handle:close()

  local path = result:match("(%S+)")
  if not path then
    error("File not found: " .. filename)
  end

  return path
end

function M.find_schema_filename(schema)
  local p = io.popen('ls -1 "' .. M.schema_folder .. '"') -- -1 ensures one file per line
  if not p then return nil end

  for filename in p:lines() do
    if filename:find('-' .. schema .. '.sql', 1, true) then
      p:close()
      return filename
    end
  end

  p:close()
  error("Schema file not found for schema: " .. schema)
end

function M.open_files_in_new_tab(files)
  local n = #files
  if n == 0 then error("No files provided") end

  -- Validate files exist
  for _, f in ipairs(files) do
    if vim.fn.filereadable(f) == 0 then
      error("File does not exist: " .. f)
    end
  end

  -- Open new tab with first file
  vim.cmd("tabnew")
  vim.cmd("edit " .. files[1])

  local col_windows = { vim.api.nvim_get_current_win() }
  local next_file = 2

  -- Create up to 2 more vertical splits (max 3 columns)
  while #col_windows < math.min(3, n) do
    vim.cmd("vsplit")
    vim.cmd("edit " .. files[next_file])
    next_file = next_file + 1
    table.insert(col_windows, vim.api.nvim_get_current_win())
  end

  -- Track how many horizontal splits each column has
  local col_hsplits = {}
  for i = 1, #col_windows do col_hsplits[i] = 0 end

  -- Add remaining files as horizontal splits
  while next_file <= n do
    -- Find the column with the fewest horizontal splits
    local min_splits = math.huge
    local col_idx = 1
    for i = 1, #col_hsplits do
      if col_hsplits[i] < min_splits then
        min_splits = col_hsplits[i]
        col_idx = i
      end
    end

    -- Check rules:
    -- - horizontal splits <= 1 + number of vertical splits in any row
    -- - vertical splits <= 1 + number of horizontal splits in any column
    -- Since vertical splits are capped at 3, this is safe

    vim.api.nvim_set_current_win(col_windows[col_idx])
    vim.cmd("split")
    vim.cmd("edit " .. files[next_file])
    col_hsplits[col_idx] = col_hsplits[col_idx] + 1

    next_file = next_file + 1
  end

  -- Balance all splits
  vim.cmd("wincmd =")
end

return M
