# Neovim config

Started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), reorganized by function.
Managed with chezmoi (`~/.local/share/chezmoi/dot_config/nvim`).

## Layout

```
init.lua                 leader + loads lua/config/*
lua/config/
  options.lua            editor options (incl. spell, folding)
  keymaps.lua            general keymaps (windows, buffers, basics)
  autocmds.lua           general autocommands
  lazy.lua               lazy.nvim bootstrap
lua/plugins/             one file per category; each plugin's keymaps live with it
  ui.lua                 colorscheme, which-key (leader groups), statusline, bufferline, noice
  editor.lua             telescope, oil, flash, surround, autopairs, todo-comments, trouble
  lsp.lua                servers + per-server settings, mason tool list, LSP keymaps
  completion.lua         blink.cmp + LuaSnip
  formatting.lua         conform (format on save) + nvim-lint
  treesitter.lua         treesitter, context, neogen
  git.lua                gitsigns, neogit, diffview, octo
  debug.lua              nvim-dap
  test.lua               neotest
lua/util/git.lua         merge-base / async git helpers
```

## Keymaps

| Prefix              | Group                                                        |
| ------------------- | ------------------------------------------------------------ |
| `<leader>s`         | Search (telescope) — `<leader><leader>` buffers, `<leader>/` in buffer |
| `<leader>b`         | Buffer — `n`/`p` cycle, `g` pick, `c` close                  |
| `<leader>w`         | Window — split/move/resize                                   |
| `<leader>c`         | Code — `f` format, `g` generate docstring                    |
| `<leader>x`         | Diagnostics (trouble) — `x` workspace, `X` buffer, `q` quickfix |
| `<leader>g`         | Git — `g` Neogit, `d`/`D` diffview (vs branch base), `f` file history, `pl`/`ps` pull/push |
| `<leader>h`         | Git hunk — stage/reset/preview/blame, `B`/`X` diff base      |
| `<leader>o`         | GitHub (Octo) — issues, PRs, notifications, search           |
| `<leader>d`         | Debug — breakpoints, `u` UI; also `<F1-3,5,7>`               |
| `<leader>t`         | Test — nearest, file, debug, output, summary                 |
| `<leader>u`         | UI toggles — inlay hints, line blame, deleted lines, spell   |
| `gr*`, `gO`, `gW`   | LSP — `grd` definition, `grr` references, `gri`, `grt`, `grD`, `grn` rename, `gra` action |
| `-`                 | Oil (file explorer); `H` toggles hidden files                |
| `s` / `S`           | Flash jump / treesitter select                               |
| `ys` / `ds` / `cs`  | Surround add / delete / change                               |
