-- Editor options. See `:help option-list`.
local o = vim.o

-- Line numbers & gutter
o.number = true
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true
o.colorcolumn = '88'

-- Editing
o.mouse = 'a'
o.breakindent = true
o.undofile = true
o.confirm = true -- ask to save instead of failing on :q with unsaved changes

-- Sync with the OS clipboard (scheduled because it can slow startup)
vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)

-- Search
o.ignorecase = true
o.smartcase = true
o.inccommand = 'split' -- live preview of :s substitutions

-- Splits
o.splitright = true
o.splitbelow = true

-- Display
o.showmode = false -- mode is already in the statusline
o.scrolloff = 10
o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Timing
o.updatetime = 250
o.timeoutlen = 300

-- Spelling
o.spelllang = 'en_us'
o.spell = true

-- Folding: treesitter-based, all folds open when a file is opened
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevelstart = 99
