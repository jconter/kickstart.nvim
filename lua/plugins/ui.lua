-- UI: colorscheme, keymap hints, statusline, bufferline, messages, visual guides.
return {
  { -- Colorscheme
    'EdenEast/nightfox.nvim',
    priority = 1000, -- load before other start plugins
    config = function()
      vim.cmd.colorscheme 'nightfox'
    end,
  },

  { -- Pending-keymap popup; the leader groups below are the map of this config
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>b', group = 'Buffer' },
        { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
        { '<leader>d', group = 'Debug' },
        { '<leader>g', group = 'Git' },
        { '<leader>gp', group = 'Pull/Push' },
        { '<leader>h', group = 'Git hunk', mode = { 'n', 'v' } },
        { '<leader>o', group = 'GitHub (Octo)' },
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Test' },
        { '<leader>u', group = 'UI toggles' },
        { '<leader>w', group = 'Window' },
        { '<leader>x', group = 'Diagnostics' },
        { 'gr', group = 'LSP' },
      },
    },
  },

  { -- Statusline
    'nvim-mini/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      require('mini.ai').setup { n_lines = 500 } -- better a/i textobjects (see editor.lua)
    end,
  },

  { -- Buffer tabs
    'akinsho/bufferline.nvim',
    version = '*',
    event = 'VeryLazy',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {},
    keys = {
      { '<leader>bn', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { '<leader>b]', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
      { '<leader>b[', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
      { '<leader>bg', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
    },
  },

  { -- Cmdline, messages and notifications UI
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    opts = {
      lsp = {
        -- render LSP markdown with treesitter
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
        progress = { enabled = false }, -- fidget shows LSP progress
        signature = { enabled = false }, -- blink.cmp shows signature help
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },

  { -- Indentation guides
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  { -- Render markdown in the buffer
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
