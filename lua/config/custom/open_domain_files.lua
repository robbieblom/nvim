local util = require('config.custom.util')

local M = {}

local function match_befe(str)
  local be_match = string.match(str, 'be')
  local fe_match = string.match(str, 'fe')
  return { be_match, fe_match }
end

--[[
9 different domain files to open:
  - be sdk operation file
  - be sdk types file
  - fe sdk operation file
  - fe sdk types file
  - be client file
  - fe client file
  - api endpoint file
  - views file
  - some schema file

Usage: [be,fe operationEntity types client]* (path)* {schema*}*
]]
function M.open_domain_files(opts)
  local files_to_open = {}
  for sdk_match in string.gmatch(opts.args, '%b[]') do
    local sdksargs = sdk_match:sub(2, -2)
    local sdkargs = {}
    for w in sdksargs:gmatch("%S+") do
      table.insert(sdkargs, w)
    end

    for _, sdk_type in ipairs(match_befe(sdkargs[1])) do
      local operation_entity = sdkargs[2]
      local types = sdkargs[3]
      local client = sdkargs[4]

      local sdk_operation_filename = (sdk_type == 'be' and '_' .. operation_entity .. '.ts') or operation_entity .. '.ts'
      local resolved_sdk_operation_path = util.find_resolved_path_of_file(sdk_operation_filename, { util.sdk_folder })
      table.insert(files_to_open, resolved_sdk_operation_path)

      local resolved_sdk_types_path = nil
      if types == 'types' then
        resolved_sdk_types_path = vim.fn.fnamemodify(resolved_sdk_operation_path, ":h") .. "/types.ts"
        table.insert(files_to_open, resolved_sdk_types_path)
      end

      local resolved_client_path = nil
      if client == 'client' then
        resolved_client_path = util.resolve_client_path(sdk_type)
        table.insert(files_to_open, resolved_client_path)
      end
    end
  end

  for api_match in string.gmatch(opts.args, '%b()') do
    local path = api_match:sub(2, -2)
    path = path:gsub("^/", ""):gsub("/$", "") .. "/route.ts"
    local resolved_api_path = util.resolve_api_path(path)
    table.insert(files_to_open, resolved_api_path)
  end

  for schema_match in string.gmatch(opts.args, '%b{}') do
    local schemasargs = schema_match:sub(2, -2)
    local schemaargs = {}
    for w in schemasargs:gmatch("%S+") do
      table.insert(schemaargs, w)
    end

    for _, schema in ipairs(schemaargs) do
      local schema_filename = util.find_schema_filename(schema)
      local resolved_schema_path = util.find_resolved_path_of_file(schema_filename, { util.schema_folder })
      table.insert(files_to_open, resolved_schema_path)
    end
  end

  util.open_files_in_new_tab(files_to_open)
end

vim.api.nvim_create_user_command("OpenDomainFiles", function(opts)
  M.open_domain_files(opts)
end, { nargs = "*" })

return M
