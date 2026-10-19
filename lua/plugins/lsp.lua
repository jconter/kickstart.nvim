-- LSP: servers, installers (mason), LSP keymaps and diagnostics display.
-- Completion is in completion.lua; formatting/linting in formatting.lua.

-- Per-server settings, passed to vim.lsp.config(). Any other server installed
-- through :Mason is enabled automatically with its default config.
local servers = {
  pyright = {
    settings = {
      python = { analysis = { typeCheckingMode = 'strict' } },
    },
  },
  lua_ls = {
    settings = {
      Lua = { completion = { callSnippet = 'Replace' } },
    },
  },
  ts_ls = {
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    init_options = {
      plugins = {
        { -- lets ts_ls understand <script> blocks in .vue files (vue_ls v3 needs this)
          name = '@vue/typescript-plugin',
          location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
          languages = { 'vue' },
          configNamespace = 'typescript',
        },
      },
    },
  },
  vue_ls = {},
}

-- Everything mason should install (mason package names).
local tools = {
  -- language servers
  'pyright',
  'lua-language-server',
  'typescript-language-server',
  'vue-language-server',
  -- formatters
  'stylua',
  'black',
  'isort',
  'prettierd',
  -- linters
  'markdownlint',
  'pylint',
  'ruff',
  'mypy',
}

return {
  { -- Lua LSP that knows about the Neovim API
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
    },
  },

  { -- Package manager for LSPs/formatters/linters; puts them on PATH, so load it eagerly
    'mason-org/mason.nvim',
    lazy = false,
    opts = {},
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    dependencies = { 'mason-org/mason.nvim' },
    opts = { ensure_installed = tools },
  },

  { -- LSP progress spinner
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp', -- sets completion capabilities for every server
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local function map(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local telescope = require 'telescope.builtin'

          -- Goto / actions (gr prefix, matching Neovim's defaults)
          map('grn', vim.lsp.buf.rename, 'Rename')
          map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
          map('grr', telescope.lsp_references, 'References')
          map('gri', telescope.lsp_implementations, 'Implementation')
          map('grd', telescope.lsp_definitions, 'Definition')
          map('grD', vim.lsp.buf.declaration, 'Declaration')
          map('grt', telescope.lsp_type_definitions, 'Type definition')
          map('gO', telescope.lsp_document_symbols, 'Document symbols')
          map('gW', telescope.lsp_dynamic_workspace_symbols, 'Workspace symbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          -- Highlight references of the word under the cursor
          if client:supports_method('textDocument/documentHighlight', event.buf) then
            local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>uh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle inlay hints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = { source = 'if_many', spacing = 2 },
      }

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
      end
      -- Enables every server installed through mason (including the ones above)
      require('mason-lspconfig').setup { ensure_installed = {}, automatic_enable = true }
    end,
  },
}
