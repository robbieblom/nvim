return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        sql = { "sql_formatter" },
        -- tex = { "latexindent" },
        ps1 = { "pwsh" }
      },
      formatters = {
        sql_formatter = {
          command = "sql-formatter",
          args = { "--language", "postgresql" },
          stdin = true,
        },
        pwsh = {
          command = "pwsh",
          args = {
            "-NoProfile",
            "-Command",
            "Invoke-Formatter -ScriptDefinition ([Console]::In.ReadToEnd())",
          },
          stdin = true,
        }
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 5000,
        lsp_format = "fallback",
      },
    })
  end,
}
