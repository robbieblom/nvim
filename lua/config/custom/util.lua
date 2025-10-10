local M = {}

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

return M
