local null_ls = require('null-ls')

local opts = {
	debug = true,
	sources = {
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.prettier,
		-- null_ls.builtins.diagnostics.mypy.with({
		-- 	-- prefer_local = 'venv/bin/',
		-- 	command = "mypy",
		-- 	extra_args = {
		-- 		"--strict",
		-- 		"--follow-imports=normal",
		-- 	},
		-- 	env = function (params)
		-- 		return { PYTHONPATH = params.root }
		-- 	end,
		-- }),
		-- null_ls.builtins.diagnostics.pylint.with({
		-- 	-- prefer_local = 'venv/bin/',
		-- 	command = "pylint",
		-- 	-- extra_args = {
		-- 	-- 	"--rcfile=./.pylintrc",
		-- 	-- },
		-- 	extra_args = function (params)
		-- 		return {string.format("--rcfile=%s/.pylintrc", params.root)}
		-- 	end,
		-- 	env = function (params)
		-- 		return { PYTHONPATH = params.root }
		-- 	end,
		-- }),
	}
}
return opts
