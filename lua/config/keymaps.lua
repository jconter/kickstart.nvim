-- General keymaps that don't belong to a plugin.
-- Plugin keymaps live next to their plugin in lua/plugins/<category>.lua,
-- and the leader groups are listed in lua/plugins/ui.lua (which-key).
local map = vim.keymap.set

-- Basics
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

-- Window focus
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })

-- Windows (<leader>w)
map('n', '<leader>ww', '<C-w>w', { desc = 'Next window' })
map('n', '<leader>wd', '<C-w>q', { desc = 'Close window' })
map('n', '<leader>ws', '<C-w>s', { desc = 'Split below' })
map('n', '<leader>wv', '<C-w>v', { desc = 'Split right' })
map('n', '<leader>w2', '<C-w>v', { desc = 'Split right' })
map('n', '<leader>wh', '<C-w>h', { desc = 'Focus left' })
map('n', '<leader>wj', '<C-w>j', { desc = 'Focus down' })
map('n', '<leader>wk', '<C-w>k', { desc = 'Focus up' })
map('n', '<leader>wl', '<C-w>l', { desc = 'Focus right' })
map('n', '<leader>wH', '<C-w>5<', { desc = 'Narrower' })
map('n', '<leader>wL', '<C-w>5>', { desc = 'Wider' })
map('n', '<leader>wJ', '<cmd>resize +5<CR>', { desc = 'Taller' })
map('n', '<leader>wK', '<cmd>resize -5<CR>', { desc = 'Shorter' })
map('n', '<leader>w=', '<C-w>=', { desc = 'Equalize sizes' })

-- Buffers (<leader>b) — cycling/picking is in lua/plugins/ui.lua (bufferline)
map('n', '<leader>bc', '<cmd>bwipeout<CR>', { desc = 'Close buffer' })

-- UI toggles (<leader>u) — plugin toggles live with their plugin
map('n', '<leader>us', function()
  vim.o.spell = not vim.o.spell
end, { desc = 'Toggle spell check' })
