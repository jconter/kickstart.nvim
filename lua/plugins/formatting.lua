-- Formatting (conform, runs on save) & linting (nvim-lint).
-- Tools are installed by mason; see the `tools` list in lsp.lua.
local prettier = { 'prettierd', 'prettier', stop_after_first = true }
local golangci_configs = { '.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json' }

return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_organize_imports', 'ruff_format' },
        -- Go: the repo's own golangci-lint formatters (same as CI) when it has a
        -- config, plain goimports otherwise
        go = { 'golangci-lint', 'goimports', stop_after_first = true },
        rust = { 'rustfmt' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        vue = prettier,
        css = prettier,
        html = prettier,
        json = prettier,
        yaml = prettier,
      },
      formatters = {
        ['golangci-lint'] = {
          cwd = function(self, ctx)
            return require('conform.util').root_file(golangci_configs)(self, ctx)
          end,
          require_cwd = true, -- unavailable outside repos with a golangci config
        },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      local group = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = group,
        callback = function()
          -- skip read-only buffers such as LSP hover popups
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
      -- golangci-lint checks the whole package and is slow on big repos: save only
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = group,
        pattern = '*.go',
        callback = function()
          lint.try_lint 'golangcilint'
        end,
      })
    end,
  },
}
