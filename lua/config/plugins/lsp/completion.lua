return {
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrs7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp"
  },
  { 'saadparwaiz1/cmp_luasnip' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
      })

      -- Set up lspconfig.
      -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require('lspconfig')['lua_ls'].setup {
        capabilities = capabilities
      }
      require('lspconfig')['bashls'].setup {
        capabilities = capabilities
      }
      require('lspconfig')['pyright'].setup {
        capabilities = capabilities
      }

      -- for html
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      require 'lspconfig'.html.setup {
        capabilities = capabilities,
      }

      -- for css
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      require 'lspconfig'.cssls.setup {
        capabilities = capabilities,
      }

      require 'lspconfig'.tsserver.setup {
        capabilities = capabilities,
      }
    end
  },
}
