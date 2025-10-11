local util = require('config.custom.util')

local M = {}

function M.add_api_endpoint(opts)
  local verb = opts.fargs[1]
  local path = opts.fargs[2]

  if not verb or not path then
    print("Usage: :AddApiEndpoint <HTTP verb> <path>")
    return
  end

  local resolved_folder_path = util.resolve_api_path(path)
  local resolved_file_path = resolved_folder_path .. "/route.ts"

  if vim.fn.isdirectory(resolved_folder_path) == 0 then
    vim.fn.mkdir(resolved_folder_path, "p")
  end

  local file = io.open(resolved_file_path, "w")
  if not file then
    error("Failed to open file: " .. resolved_file_path)
  end

  local lines = {
    'import { auth } from "@clerk/nextjs/server";',
    'import { type NextRequest } from "next/server";',
    'import BTIBackendClient from "@/app/sdk/be/client";',
    'import { checkRole } from "@/app/util/roles";',
    'import { currentUser } from "@clerk/nextjs/server";',
    "",
    string.format('export async function %s(request: NextRequest) {', verb:upper()),
    '  await auth.protect();',
    '  const btibe = new BTIBackendClient({ type: "api-rls" });',
    '  await btibe.connect({ txn: true });',
    '  try {',
    '    return new Response(JSON.stringify({}), {',
    '      headers: {',
    '        "content-type": "application/json",',
    '      },',
    '    });',
    '  } catch (error) {',
    string.format('    console.error("Error with %s %s:", error);', verb:upper(), path),
    string.format('    return new Response("Failed %s %s", { status: 500 });', verb:upper(), path),
    '  } finally {',
    '    await btibe.end();',
    '  }',
    '}'
  }

  for i, line in ipairs(lines) do
    file:write(line)
    if i < #lines then
      file:write("\n")
    end
  end
  file:close()
end

vim.api.nvim_create_user_command("AddApiEndpoint", function(opts)
  M.add_api_endpoint(opts)
end, { nargs = "*" })

return M
