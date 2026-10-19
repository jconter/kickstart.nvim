-- Editing & navigation: finder, file explorer, motions, text objects, pairs, TODOs, diagnostics list.
return {
  'NMAC427/guess-indent.nvim', -- detect tabstop/shiftwidth automatically

  { -- Fuzzy finder (<leader>s)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      local map = vim.keymap.set
      map('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
      map('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
      map('n', '<leader>sf', builtin.find_files, { desc = 'Files' })
      map('n', '<leader>ss', builtin.builtin, { desc = 'Telescope pickers' })
      map('n', '<leader>sw', builtin.grep_string, { desc = 'Current word' })
      map('n', '<leader>sg', builtin.live_grep, { desc = 'Grep' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
      map('n', '<leader>sr', builtin.resume, { desc = 'Resume last search' })
      map('n', '<leader>s.', builtin.oldfiles, { desc = 'Recent files' })
      map('n', '<leader><leader>', builtin.buffers, { desc = 'Find buffer' })
      map('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end, { desc = 'Fuzzy search in buffer' })
      map('n', '<leader>s/', function()
        builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = 'Grep open files' })
      map('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Neovim config files' })
    end,
  },

  { -- File explorer as a buffer (replaces netrw)
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      keymaps = {
        ['H'] = { 'actions.toggle_hidden', desc = 'Toggle hidden files' },
      },
    },
    keys = {
      { '-', '<cmd>Oil<CR>', desc = 'Open parent directory' },
    },
  },

  { -- Jump anywhere with s / S
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
  },

  { -- Surround: ys{motion}{char}, ds{char}, cs{old}{new}
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {},
  },

  { -- Auto-close brackets and quotes
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  { -- Highlight and search TODO/FIXME/NOTE comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = {
      { '<leader>st', '<cmd>TodoTelescope<CR>', desc = 'TODOs' },
    },
  },

  { -- Diagnostics / references list (<leader>x)
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Workspace diagnostics' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer diagnostics' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix list' },
    },
  },
}
