-- Testing (neotest, <leader>t): Go (go test), TypeScript (vitest), Python (pytest).
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      { 'fredrikaverpil/neotest-golang', version = '*' },
      'marilari88/neotest-vitest',
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
      -- neotest-vitest only looks for vitest in the nearest and git-root package.json
      -- (and prints errors when they're missing). Monorepos like nt declare it in a
      -- package.json in between, so check every ancestor instead.
      -- (plain io.open: neotest calls this from async context, where vim.fn is not allowed)
      local function uses_vitest(path)
        for dir in vim.fs.parents(path) do
          local f = io.open(dir .. '/package.json', 'r')
          if f then
            local ok, pkg = pcall(vim.json.decode, f:read '*a')
            f:close()
            if ok and type(pkg) == 'table' and ((pkg.devDependencies or {}).vitest or (pkg.dependencies or {}).vitest) then
              return true
            end
          end
        end
        return false
      end
      local vitest = require 'neotest-vitest' {}
      vitest.is_test_file = function(path)
        if not path or path:match '/node_modules/' then
          return false
        end
        local named = path:match '__tests__' or path:match '%.test%.[jt]sx?$' or path:match '%.spec%.[jt]sx?$'
        return named ~= nil and uses_vitest(path)
      end

      require('neotest').setup {
        adapters = {
          require 'neotest-golang' {},
          vitest,
          require 'neotest-python',
        },
      }
    end,
  },
}
