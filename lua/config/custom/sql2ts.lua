local util = require('config.custom.util')

local M = {}

-- crude type mapping
local type_map = {
  ["integer"] = "number",
  ["int"] = "number",
  ["uuid"] = "string",
  ["text"] = "string",
  ["varchar"] = "string",
  ["timestamptz"] = "Date",
  ["timestamp"] = "Date",
  ["boolean"] = "boolean",
}

function M.sql_to_ts_interface(lines)
  local cols = {}
  local table_name = "Unknown"

  for _, line in ipairs(lines) do
    -- strip commas/extra whitespace
    local l = line:gsub("[,()]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if l:match("^CREATE TABLE") then
      table_name = l:match("CREATE TABLE%s+([%w_%.]+)")
      if table_name and table_name:find("%.") then
        table_name = table_name:match("%.(.+)") -- drop schema prefix
      end
      table_name = "_" .. util.capitalize(util.to_camel_case(table_name))
    elseif not l:upper():match("^UNIQUE") and not l:upper():match("^PRIMARY") and not l:match("^%);") then
      local name, ptype = l:match("([%w_]+)%s+([%w]+)")
      if name and ptype then
        local ts_type = type_map[ptype:lower()] or "any"
        local nullable = l:match("DEFAULT NULL") or (l:match("NULL") and not l:match("NOT NULL"))
        if nullable then ts_type = ts_type .. " | null" end
        table.insert(cols, string.format("  %s: %s;", util.to_camel_case(name), ts_type))
      end
    end
  end

  local iface = {}
  table.insert(iface, "export interface " .. util.capitalize(table_name) .. " {")
  vim.list_extend(iface, cols)
  table.insert(iface, "}")
  return iface
end

function M.to_ts_interface()
  local start_pos = vim.fn.getpos("'<")[2]
  local end_pos = vim.fn.getpos("'>")[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_pos - 1, end_pos, false)
  local iface = M.sql_to_ts_interface(lines)
  vim.api.nvim_put(iface, "l", false, true)
end

vim.api.nvim_create_user_command("ToTSInterface", function()
  M.to_ts_interface()
end, { range = true })

return M
