return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  config = function()
    local neot = require 'neotest'
    neot.setup {
      adapters = {
        require 'neotest-python',
      },
    }
    vim.keymap.set('n', '<leader>tn', function()
      neot.run.run()
    end, { desc = 'Run nearest test' })
    vim.keymap.set('n', '<leader>tf', function()
      neot.run.run(vim.fn.expand '%')
    end, { desc = 'Test the current file' })
    vim.keymap.set('n', '<leader>td', function()
      neot.run.run { strategy = 'dap' }
    end, { desc = 'Test and Debug the current file' })
    vim.keymap.set('n', '<leader>ts', function()
      neot.run.stop()
    end, { desc = 'Stop the nearest test' })
    vim.keymap.set('n', '<leader>ta', function()
      neot.run.attach()
    end, { desc = 'Attach to the nearest test' })
  end,
}
