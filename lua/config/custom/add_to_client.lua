local util = require('config.custom.util')

local M = {}

-- Command for Neovim: :GenerateWrapper fetch qualification
function M.add_to_client(opts)
  local operation = opts.fargs[1]
  local entity = opts.fargs[2]
  local paths = opts.fargs[3]

  if not operation or not entity or not paths then
    print("Usage: :GenerateWrapper <operation> <entity> <folder1 folder2 ...>")
    return
  end

  local sdk_types = util.resolve_sdk_types(paths)
  local sdk_folder = util.resolve_sdk_folder(paths)
  for _, sdk_type in ipairs(sdk_types) do
    local method_name = util.resolve_method_name(operation, entity, sdk_type)
    local params_name = util.resolve_params_type(operation, entity, sdk_type)

    local import_lines = {}
    local method_defn_lines = {}
    table.insert(import_lines, string.format(
      'import { %s,  %s,} from "./%s/%s";',
      method_name,
      params_name,
      sdk_folder,
      method_name
    ))
    table.insert(method_defn_lines,
      string.format("  async %s(params: %s) {", method_name, params_name))
    table.insert(method_defn_lines,
      string.format("    return await %s({ uss%s: this, ...params });", method_name, sdk_type))
    table.insert(method_defn_lines, "  }")

    local resolved_client_path = util.resolve_client_path(sdk_type)
    local bufnr = vim.fn.bufnr(resolved_client_path, true)
    if bufnr == -1 then
      print("Client file not found: " .. resolved_client_path)
      return
    end
    vim.fn.bufload(bufnr)

    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, import_lines)
    local lnnr, col = util.search_buffer(bufnr, string.format('// %s methods', sdk_folder))
    if lnnr then
      table.insert(method_defn_lines, "")
      vim.api.nvim_buf_set_lines(bufnr, lnnr, lnnr, false, method_defn_lines)
    else
      lnnr, col = util.search_buffer(bufnr, "}", false, true)
      if lnnr then
        table.insert(method_defn_lines, 1, "")
        table.insert(method_defn_lines, 2, "  // " .. sdk_folder .. " methods")
        vim.api.nvim_buf_set_lines(bufnr, lnnr - 1, lnnr - 1, false, method_defn_lines)
      else
        print("Could not find insertion point in " .. resolved_client_path)
        return
      end
    end
  end
end

vim.api.nvim_create_user_command("AddToClient", function(opts)
  M.add_to_client(opts)
end, { nargs = "*" })

return M
