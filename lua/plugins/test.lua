-- Testing (neotest, <leader>t).
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
    },
    -- stylua: ignore
    keys = {
      { '<leader>tn', function() require('neotest').run.run() end, desc = 'Run nearest test' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Run file' },
      { '<leader>td', function() require('neotest').run.run { strategy = 'dap' } end, desc = 'Debug nearest test' },
      { '<leader>ts', function() require('neotest').run.stop() end, desc = 'Stop nearest test' },
      { '<leader>ta', function() require('neotest').run.attach() end, desc = 'Attach to nearest test' },
      { '<leader>to', function() require('neotest').output.open { enter = true } end, desc = 'Show output' },
      { '<leader>tS', function() require('neotest').summary.toggle() end, desc = 'Toggle summary' },
    },
    config = function()
      require('neotest').setup {
        adapters = { require 'neotest-python' },
      }
    end,
  },
}
