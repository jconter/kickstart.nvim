local opts = { silent = true }

-- buffer commands
vim.keymap.set('n', '<leader>b]', '<cmd>lua require("bufferline").cycle(1)<CR>', opts)

vim.keymap.set('n', '<leader>bn', '<cmd>lua require("bufferline").cycle(1)<CR>', opts)

vim.keymap.set('n', '<leader>bg', '<cmd>lua require("bufferline").pick_buffer()<CR>', opts)

vim.keymap.set('n', '<leader>b[', '<cmd>lua require("bufferline").cycle(-1)<CR>', opts)

vim.keymap.set('n', '<leader>bp', '<cmd>lua require("bufferline").cycle(-1)<CR>', opts)

vim.keymap.set('n', '<leader>bc', '<cmd>bwipeout<CR>', opts)

-- window
vim.keymap.set('n', '<leader>ww', '<C-w>w', opts)
vim.keymap.set('n', '<leader>wd', '<C-w>q', opts)
vim.keymap.set('n', '<leader>ws', '<C-W>s', opts)
vim.keymap.set('n', '<leader>wv', '<C-w>v', opts)
vim.keymap.set('n', '<leader>w2', '<C-w>v', opts)
vim.keymap.set('n', '<leader>wh', '<C-w>h', opts)
vim.keymap.set('n', '<leader>wj', '<C-w>j', opts)
vim.keymap.set('n', '<leader>wl', '<C-w>l', opts)
vim.keymap.set('n', '<leader>wk', '<C-w>k', opts)
vim.keymap.set('n', '<leader>wH', '<C-W>5<', opts)
vim.keymap.set('n', '<leader>wJ', '<cmd>resize +5<CR>', opts)
vim.keymap.set('n', '<leader>wL', '<C-W>5>', opts)
vim.keymap.set('n', '<leader>wK', '<cmd>resize -5<CR>', opts)
vim.keymap.set('n', '<leader>w=', '<C-W>=', opts)

--Oil
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

--Diffview
vim.keymap.set('n', '<leader>dvo', '<CMD>DiffviewOpen<CR>', { desc = 'Diffview Open' })
vim.keymap.set('n', '<leader>dvb', function()
  local base = require('custom.core.git_base').merge_base()
  if base then
    vim.cmd('DiffviewOpen ' .. base)
  end
end, { desc = 'Diffview vs branch base (merge-base)' })

--Git
vim.keymap.set('n', '<leader>gt', '<CMD>Neogit<CR>', { desc = 'Open Git Viewer' })
vim.keymap.set('n', '<leader>gpl', '<CMD>Git pull<CR>', { desc = 'Git pull on current branch' })
vim.keymap.set('n', '<leader>gps', '<CMD>Git push<CR>', { desc = 'Git push on current branch' })
