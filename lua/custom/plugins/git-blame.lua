return {
	'f-person/git-blame.nvim',
	opts = {},
	config = function ()
		require('gitblame').setup {
			enabled = true,
		}
	end
}
