local asdko = require('config.custom.add_sdk_operation')
local aapie = require('config.custom.add_api_endpoint')

local M = {}

-- [operation entity [be|fe]/folder ] (verb path) ...
vim.api.nvim_create_user_command("ExposeOperation", function(opts)
  for sdk_match in string.gmatch(opts.args, '%b[]') do
    local sargs = sdk_match:sub(2, -2)
    local args = {}
    for w in sargs:gmatch("%S+") do
      table.insert(args, w)
    end

    local operation, entity, paths, sketchReturnTypes = unpack(args)
    asdko.add_sdk_operation({ fargs = { operation, entity, paths, sketchReturnTypes } })
  end

  for api_match in string.gmatch(opts.args, '%b()') do
    local sargs = api_match:sub(2, -2)
    local args = {}
    for w in sargs:gmatch("%S+") do
      table.insert(args, w)
    end

    local verb, path = unpack(args)
    aapie.add_api_endpoint({ fargs = { verb, path } })
  end
end, { nargs = "*" })

return M
