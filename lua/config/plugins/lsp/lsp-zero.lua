return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ['r_language_server'] = { 'r' },
          ['lua_ls'] = { 'lua' }
        }
      })


      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })
    end
  },

  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({})
    end
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'VonHeikemen/lsp-zero.nvim' },
    config = function()
      local lsp_zero = require('lsp-zero')
      require('mason-lspconfig').setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          "cssls",
          -- "ts_ls",
          "tsserver",
          "eslint",
          "html",
          -- "dockerls",
          -- "docker_compose_language_service",
          "jsonls",
          -- "mdx_analyzer",
          "marksman",
          "pyright",
          "sqlls",
          "r_language_server",
          "texlab",
        },
        handlers = {
          lsp_zero.default_setup,
        },
      })
    end
  },

  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        preselect = 'item',
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
      })
    end
  },
  { 'L3MON4D3/LuaSnip' },
}
