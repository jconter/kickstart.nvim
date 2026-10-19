-- Bootstrap lazy.nvim and load every spec in lua/plugins/.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = { { import = 'plugins' } },
  install = { colorscheme = { 'nightfox' } },
  change_detection = { notify = false },
  rocks = { enabled = false }, -- no plugin here needs luarocks
  performance = {
    rtp = {
      -- Built-in plugins we never use (oil replaces netrw)
      disabled_plugins = { 'gzip', 'netrwPlugin', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin' },
    },
  },
}
