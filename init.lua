-- Neovim config entry point. See README.md for the layout and keymap overview.

-- Leader must be set before any plugin or keymap is defined.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'
