-- 🤖 jconter
return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- OR 'ibhagwan/fzf-lua',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  keys = {
    { '<leader>oi', '<CMD>Octo issue list<CR>', desc = 'Octo: list issues' },
    { '<leader>op', '<CMD>Octo pr list<CR>', desc = 'Octo: list pull requests' },
    { '<leader>od', '<CMD>Octo discussion list<CR>', desc = 'Octo: list discussions' },
    { '<leader>on', '<CMD>Octo notification list<CR>', desc = 'Octo: list notifications' },
    {
      '<leader>os',
      function()
        require('octo.utils').create_base_search_command { include_current_repo = true }
      end,
      desc = 'Octo: search GitHub',
    },
  },
  config = function ()
    require"octo".setup({
      -- 🤖 Write PR files to real temp files during review instead of virtual
      -- octo:// buffers, so LSPs (gopls, etc.) get a valid file:// URI instead
      -- of throwing "DocumentURI scheme is not 'file'" JSON-RPC parse errors.
      use_local_fs = true,
    })

    -- 🤖 Belt-and-suspenders: if a virtual octo:// buffer ever shows up anyway
    -- (use_local_fs can't resolve every file locally), detach any LSP client
    -- that tries to attach to it instead of letting it error out.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('octo_lsp_detach', { clear = true }),
      callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if bufname:match('^octo://') then
          vim.lsp.buf_detach_client(args.buf, args.data.client_id)
        end
      end,
    })
  end
}
