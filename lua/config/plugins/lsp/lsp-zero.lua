return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })
        lsp_zero.buffer_autoformat()
        local opts = { buffer = bufnr }

        vim.keymap.set({ 'n', 'x' }, 'gq', function()
          vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
        end, opts)

        lsp_zero.set_sign_icons({
          error = '✘',
          warn = '▲',
          hint = '⚑',
          info = '»'
        })
      end)
    end
  },

  --- Uncomment the two plugins below if you want to manage the language servers from neovim
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
      lsp_zero.extend_lspconfig()

      require('mason-lspconfig').setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          "dockerls",
          "docker_compose_language_service",
          "jsonls",
          "tsserver",
          "marksman",
          "pyright",
          "sqlls",
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
