return {
	'WhoIsSethDaniel/mason-tool-installer.nvim',
	dependencies = {
		'williamboman/mason.nvim'
	},
	config = function ()
		require('mason-tool-installer').setup {
			ensure_installed = {
				'pylint',
				'ruff',
				'mypy',
				'black',
				'isort',
			}
		}
	end
}
