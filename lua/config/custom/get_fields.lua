local util = require('config.custom.util')

local M = {}


-- Extract interface field names from a file, return snake_case fields array
local function extract_interface_fields(entity, filepath)
  local iface_name = "_" .. entity:sub(1, 1):upper() .. entity:sub(2) -- _Qualification
  local inside_iface = false
  local fields = {}

  local f, err = io.open(filepath, "r")
  if not f then
    vim.notify("Could not open file: " .. tostring(filepath) .. " — " .. tostring(err), vim.log.levels.ERROR)
    return fields
  end

  for rawline in f:lines() do
    -- defend against Windows CRLF
    local line = rawline:gsub("\r$", "")

    -- start of the interface (allow spaces before export)
    if not inside_iface and line:match("^%s*export%s+interface%s+" .. iface_name .. "%s*[{]") then
      inside_iface = true
    elseif inside_iface then
      -- end of interface
      if line:match("^%s*}") then
        break
      end

      -- capture field name like:  name?: string;   or  createdAt: Date | null;
      -- pattern explanation:
      -- ^%s*         leading whitespace
      -- ([%w_]+)     capture identifier (letters,digits,underscore)
      -- %s*%??%s*    optional "?" (e.g. optional property) with optional spaces
      -- :            colon that separates name from type
      local field = line:match("^%s*([%w_]+)%s*%??%s*:")
      if field then
        local snake = util.to_snake_case(field)
        -- append safely without using table.insert
        if snake == field then
          fields[#fields + 1] = snake
        else
          fields[#fields + 1] = snake .. " AS " .. field
        end
      end
    end
  end

  for i = 1, #fields - 1 do
    fields[i] = fields[i] .. ","
  end

  f:close()
  return fields
end

-- command: :ExtractInterfaceFields <entity> [filepath]
vim.api.nvim_create_user_command("GetFields", function(opts)
  local entity = opts.fargs[1]
  local fallback_path = "./src/app/sdk/be/" .. entity .. "/types.ts"
  local filepath = opts.fargs[2] or fallback_path

  if not entity then
    print("Usage: :ExtractInterfaceFields <entity> [filepath]")
    return
  end

  -- debug: ensure we have a table
  local fields = extract_interface_fields(entity, filepath)
  if not fields or type(fields) ~= "table" then
    print("Extractor failed; got non-table result.")
    return
  end

  if #fields == 0 then
    print("No fields found for entity: " .. entity .. " in " .. filepath)
    return
  end

  -- Print as comma-separated in commandline
  -- print(table.concat(fields, ", "))

  -- Or insert them into buffer below cursor as separate lines:
  vim.api.nvim_put(fields, "l", false, true)
end, { nargs = "+" })

return M
