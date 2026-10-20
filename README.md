# Neovim config

Managed with chezmoi (`~/.local/share/chezmoi/dot_config/nvim`). After changing
anything here, commit in this repo and re-sync chezmoi.

## Origin: no longer kickstart

This repo started as a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
(the single big `init.lua` plus `lua/kickstart/` and `lua/custom/`). In October 2026 it was
restructured into the category layout below, and the kickstart files, docs and `:checkhealth
kickstart` were removed (commit `94a46de`; the last kickstart-shaped state is `e7bf28a`).

What that means in practice:

- **Don't merge upstream kickstart.** Its changes land in one `init.lua` that no longer exists
  here. To pick up an upstream improvement, read the kickstart commit and port it by hand into
  the matching `lua/plugins/<category>.lua` file.
- **New plugins go in the category file they belong to**, with their keymaps in the plugin's
  `keys` (or `on_attach`) and any new leader group added to the which-key `spec` in `ui.lua`.
- **New language tooling goes in `lua/plugins/lsp.lua`**: per-server settings in `servers`,
  installs in `tools`. Formatters and linters are wired up in `formatting.lua`.

## Languages

| Language     | LSP                          | Format              | Lint / extra             | Debug    |
| ------------ | ---------------------------- | ------------------- | ------------------------ | -------- |
| Python       | ty (all rules = error)       | ruff (isort + format) |                          | debugpy  |
| Go           | gopls (gofumpt, staticcheck) | goimports + gofumpt | golangci-lint            | delve    |
| Rust         | rust-analyzer (clippy)       | rustfmt (rustup)    |                          | codelldb |
| TS / JS / Vue| ts_ls + vue_ls, eslint       | prettierd           |                          |          |
| HTML/CSS/JSON/YAML | html, cssls, jsonls, yamlls | prettierd       |                          |          |
| Lua          | lua_ls + lazydev             | stylua              |                          |          |
| Shell        | bashls (+ shellcheck)        | shfmt               |                          |          |
| Markdown     |                              |                     | markdownlint             |          |

Every server installed through `:Mason` is enabled automatically.

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
