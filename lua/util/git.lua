-- Small git helpers shared by the git plugins and keymaps.
local M = {}

local function git(dir, args)
  local cmd = { 'git' }
  if dir then
    vim.list_extend(cmd, { '-C', dir })
  end
  local out = vim.fn.systemlist(vim.list_extend(cmd, args))
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return out[1]
end

-- Finds the commit where the current branch forked from the default branch,
-- so diffs show only what this branch changed (not newer commits on main).
-- dir: directory inside the repo (defaults to cwd)
-- quiet: suppress warnings (for automatic use)
function M.merge_base(dir, quiet)
  local warn = function(msg)
    if not quiet then
      vim.notify(msg, vim.log.levels.WARN)
    end
  end

  local default = git(dir, { 'rev-parse', '--abbrev-ref', 'origin/HEAD' })
  if not default then
    for _, ref in ipairs { 'origin/main', 'origin/master', 'main', 'master' } do
      if git(dir, { 'rev-parse', '--verify', '--quiet', ref }) then
        default = ref
        break
      end
    end
  end
  if not default then
    warn 'Could not find default branch (try: git remote set-head origin -a)'
    return nil
  end

  local base = git(dir, { 'merge-base', 'HEAD', default })
  if not base then
    warn('No merge-base between HEAD and ' .. default)
    return nil
  end
  return base, default
end

-- Runs `git <args>` in the background and reports the result.
function M.run(args)
  local label = 'git ' .. table.concat(args, ' ')
  vim.notify(label .. '…')
  vim.system(vim.list_extend({ 'git' }, args), { text = true }, function(res)
    vim.schedule(function()
      local output = vim.trim((res.stdout or '') .. (res.stderr or ''))
      if res.code == 0 then
        vim.notify(label .. ' done' .. (output ~= '' and ('\n' .. output) or ''))
        vim.cmd.checktime() -- reload buffers changed by a pull
      else
        vim.notify(label .. ' failed\n' .. output, vim.log.levels.ERROR)
      end
    end)
  end)
end

return M
