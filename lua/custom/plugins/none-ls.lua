return {
	"nvimtools/none-ls.nvim",
	dependencies = {"nvim-lua/plenary.nvim"},
	opts = function ()
		return require "custom.configs.none-ls"
	end,
}
