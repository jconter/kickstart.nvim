-- Git: gutter signs & hunks (<leader>h), Neogit / diffview / pull & push (<leader>g),
-- GitHub issues & PRs via Octo (<leader>o).
local git = require 'util.git'

return {
  { -- Gutter signs, hunk actions, inline blame
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true, -- toggle with <leader>ub
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Default the diff base to where this branch forked from main/master.
        -- Switch with <leader>hB / <leader>hX (sets vim.g.gitsigns_branch_base).
        if vim.g.gitsigns_branch_base ~= false then
          local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')
          local base = git.merge_base(dir, true)
          if base then
            -- Wait for gitsigns' initial update to finish; changing the base
            -- while it's in flight gets overwritten by its stale result.
            vim.api.nvim_create_autocmd('User', {
              pattern = 'GitSignsUpdate',
              callback = function(ev)
                if ev.data.buffer ~= bufnr then
                  return
                end
                if vim.api.nvim_buf_is_valid(bufnr) and vim.g.gitsigns_branch_base ~= false then
                  vim.api.nvim_buf_call(bufnr, function()
                    gitsigns.change_base(base)
                  end)
                end
                return true -- run once
              end,
            })
          end
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, 'Next git change')
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, 'Previous git change')

        -- Hunks (<leader>h)
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage hunk')
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset hunk')
        map('n', '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')
        map('n', '<leader>hS', gitsigns.stage_buffer, 'Stage buffer')
        map('n', '<leader>hu', gitsigns.stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hR', gitsigns.reset_buffer, 'Reset buffer')
        map('n', '<leader>hp', gitsigns.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', gitsigns.blame_line, 'Blame line')
        map('n', '<leader>hd', gitsigns.diffthis, 'Diff against index')
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, 'Diff against last commit')
        map('n', '<leader>hB', function()
          local base, default = git.merge_base()
          if base then
            vim.g.gitsigns_branch_base = true
            gitsigns.change_base(base, true)
            vim.notify('Gitsigns base: ' .. default .. ' merge-base (' .. base:sub(1, 8) .. ')')
          end
        end, 'Signs vs branch base')
        map('n', '<leader>hX', function()
          vim.g.gitsigns_branch_base = false
          gitsigns.reset_base(true)
          vim.notify 'Gitsigns base: index'
        end, 'Signs vs index')

        -- Toggles (<leader>u)
        map('n', '<leader>ub', gitsigns.toggle_current_line_blame, 'Toggle line blame')
        map('n', '<leader>uD', gitsigns.preview_hunk_inline, 'Toggle show deleted')
      end,
    },
  },

  { -- Git status / commit UI
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'nvim-telescope/telescope.nvim' },
    opts = {},
    keys = {
      { '<leader>gg', '<cmd>Neogit<CR>', desc = 'Neogit' },
      { '<leader>gt', '<cmd>Neogit<CR>', desc = 'Neogit' },
      -- stylua: ignore start
      { '<leader>gpl', function() git.run { 'pull' } end, desc = 'Pull' },
      { '<leader>gps', function() git.run { 'push' } end, desc = 'Push' },
      -- stylua: ignore end
    },
  },

  { -- Side-by-side diffs and file history
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'Diffview (working tree)' },
      {
        '<leader>gD',
        function()
          local base = git.merge_base()
          if base then
            vim.cmd('DiffviewOpen ' .. base)
          end
        end,
        desc = 'Diffview vs branch base',
      },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', desc = 'File history' },
    },
    opts = function()
      local actions = require 'diffview.actions'
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
        group = vim.api.nvim_create_augroup('diffview-panels', { clear = true }),
        pattern = 'diffview:///panels/*',
        callback = function()
          vim.opt_local.cursorline = true
          vim.opt_local.winhighlight = 'CursorLine:WildMenu'
        end,
      })

      return {
        enhanced_diff_hl = true,
        keymaps = {
          view = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>' },
            { 'n', '<Tab>', actions.select_next_entry },
            { 'n', '<S-Tab>', actions.select_prev_entry },
            { 'n', '<LocalLeader>a', actions.focus_files },
            { 'n', '<LocalLeader>e', actions.toggle_files },
          },
          file_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>' },
            { 'n', 'h', actions.prev_entry },
            { 'n', 'o', actions.focus_entry },
            { 'n', 'gf', actions.goto_file },
            { 'n', 'sg', actions.goto_file_split },
            { 'n', 'st', actions.goto_file_tab },
            { 'n', '<C-r>', actions.refresh_files },
            { 'n', ';e', actions.toggle_files },
          },
          file_history_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>' },
            { 'n', 'o', actions.focus_entry },
            { 'n', 'O', actions.options },
          },
        },
      }
    end,
  },

  { -- GitHub issues, PRs and reviews
    'pwntester/octo.nvim',
    cmd = 'Octo',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>oi', '<cmd>Octo issue list<CR>', desc = 'Issues' },
      { '<leader>op', '<cmd>Octo pr list<CR>', desc = 'Pull requests' },
      { '<leader>od', '<cmd>Octo discussion list<CR>', desc = 'Discussions' },
      { '<leader>on', '<cmd>Octo notification list<CR>', desc = 'Notifications' },
      {
        '<leader>os',
        function()
          require('octo.utils').create_base_search_command { include_current_repo = true }
        end,
        desc = 'Search GitHub',
      },
    },
    config = function()
      require('octo').setup {
        -- Write PR files to real temp files during review instead of virtual
        -- octo:// buffers, so LSPs (gopls, etc.) get a valid file:// URI instead
        -- of throwing "DocumentURI scheme is not 'file'" JSON-RPC parse errors.
        use_local_fs = true,
      }

      -- Belt-and-suspenders: if a virtual octo:// buffer ever shows up anyway
      -- (use_local_fs can't resolve every file locally), detach any LSP client
      -- that tries to attach to it instead of letting it error out.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('octo-lsp-detach', { clear = true }),
        callback = function(args)
          if vim.api.nvim_buf_get_name(args.buf):match '^octo://' then
            vim.lsp.buf_detach_client(args.buf, args.data.client_id)
          end
        end,
      })
    end,
  },
}
