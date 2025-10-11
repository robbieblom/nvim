local util = require('config.custom.util')
local atc = require('config.custom.add_to_client')

local M = {}


-- Generate the TypeScript template
local function generate_operation_template(operation, entity, sdk_type)
  local entity_type = util.resolve_entity_type(entity, sdk_type)
  local method_name = util.resolve_method_name(operation, entity, sdk_type)
  local params_type = util.resolve_params_type(operation, entity, sdk_type)
  local sdk_class = util.resolve_sdk_class_name(sdk_type)

  return {
    string.format('import %s from "@/app/sdk/%s/client";', sdk_class, sdk_type),
    string.format('import { %s } from "./types";', entity_type),
    "",
    string.format("export interface %s {", params_type),
    "  options?: {};",
    "}",
    "",
    "const defaultOptions = {};",
    "",
    string.format("export async function %s({", method_name),
    string.format("  uss%s,", sdk_type),
    "  options,",
    string.format("}: %s & {", params_type),
    string.format("  uss%s: %s;", sdk_type, sdk_class),
    string.format("}): Promise<%s> {", entity_type),
    "  const _options = { ...defaultOptions, ...options };",
    "",
    "}",
  }
end

-- Create new file buffer with template
local function create_ts_file(operation, entity, sdk_type, sdk_folder)
  local resolved_filename = util.resolve_sdk_filename(operation, entity, sdk_type)
  local resolved_folder_path = util.resolve_sdk_path(sdk_type .. '/' .. sdk_folder)
  local resolved_filepath = resolved_folder_path .. "/" .. resolved_filename

  -- if folder doesn't exist, create it
  if vim.fn.isdirectory(resolved_folder_path) == 0 then
    vim.fn.mkdir(resolved_folder_path, "p")
  end
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, resolved_filepath)

  local lines = generate_operation_template(operation, entity, sdk_type)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.api.nvim_buf_call(buf, function()
    vim.cmd("write")
  end)

  vim.api.nvim_buf_call(buf, function()
    vim.cmd("filetype detect")
  end)
end

local function generate_types_template(entity, sdk_type)
  local entity_type = util.resolve_entity_type(entity, sdk_type)
  if sdk_type == "be" then
    return {
      string.format("export interface %s {", entity_type),
      "}",
      "",
      string.format("export interface %sJsonEmbedded extends %s {", entity_type, entity_type),
      "}",
    }
  else
    return {
      string.format("export interface %s {", entity_type),
      "}",
    }
  end
end

local function update_types_file(entity, sdk_type, sdk_folder)
  local resolved_types_path = util.resolve_sdk_path(sdk_type .. '/' .. sdk_folder .. "/types.ts")

  -- check if file exists
  if vim.fn.filereadable(resolved_types_path) == 0 then
    -- create an empty file
    local f = io.open(resolved_types_path, "w")
    if f then
      f:close()
    else
      error("Failed to create file: " .. resolved_types_path)
    end
  end

  local bufnr = vim.fn.bufnr(resolved_types_path, true)
  if bufnr == -1 then
    error("Types file not found: " .. resolved_types_path)
  end
  vim.fn.bufload(bufnr)

  local lines = generate_types_template(entity, sdk_type)
  vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
end


function M.add_sdk_operation(opts)
  local operation = opts.fargs[1]
  local entity = opts.fargs[2]
  local paths = opts.fargs[3]
  local sketchReturnTypes = opts.fargs[4]

  if not operation or not entity or not paths then
    print("Usage: :AddSdkOperation <operation> <entity> <paths> [<sketchReturnTypes>]")
    return
  end

  local sdk_types = util.resolve_sdk_types(paths)
  local sdk_folder = util.resolve_sdk_folder(paths)
  for _, sdk_type in ipairs(sdk_types) do
    create_ts_file(operation, entity, sdk_type, sdk_folder)
    if sketchReturnTypes == 'types' then
      update_types_file(entity, sdk_type, sdk_folder)
    end
  end
  atc.add_to_client({ fargs = { operation, entity, paths } })
end

-- operation entity [be,fe]/folder types
vim.api.nvim_create_user_command("AddSdkOperation", function(opts)
  M.add_sdk_operation(opts)
end, { nargs = "*" })

return M
