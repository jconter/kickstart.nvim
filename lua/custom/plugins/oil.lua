return {
	{
		'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function ()
			require('oil').setup({
				keymaps = {
					["H"] = {
						desc = "show [H]idden files",
						callback = function ()
							require('oil').toggle_hidden()
						end
					}
				}
			})
		end
	}
}
