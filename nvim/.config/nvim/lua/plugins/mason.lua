return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"eslint-lsp",
				"prettierd",
				"stylua",
				"shellcheck",
				"sql-formatter",
			},
		},
	},
}
