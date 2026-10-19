-- Treesitter: highlighting/indent/folds, sticky context, docstring generation.
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- the main branch does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

      local function attach(buf, language)
        if not vim.treesitter.language.add(language) or not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        vim.treesitter.start(buf, language)
        if vim.treesitter.query.get(language, 'indents') then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      -- Start treesitter for every filetype, installing missing parsers on demand
      local available = ts.get_available()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
        callback = function(args)
          local language = vim.treesitter.language.get_lang(args.match)
          if not language then
            return
          end
          if vim.tbl_contains(ts.get_installed 'parsers', language) or not vim.tbl_contains(available, language) then
            attach(args.buf, language)
          else
            ts.install(language):await(function()
              attach(args.buf, language)
            end)
          end
        end,
      })
    end,
  },

  { -- Keep the current function/class header visible at the top
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  { -- Generate docstrings / annotations
    'danymat/neogen',
    cmd = 'Neogen',
    opts = {},
    keys = {
      { '<leader>cg', '<cmd>Neogen<CR>', desc = 'Generate docstring' },
    },
  },
}
