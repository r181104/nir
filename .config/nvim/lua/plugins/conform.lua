return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				-- Core langs
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				-- Other langs
				go = { "gofumpt", "goimports" },
				rust = { "rustfmt" },
				nix = { "alejandra" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				fish = { "fish_indent" },
				yaml = { "prettierd", "prettier", "yamlfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				java = { "google-java-format" },
				sql = { "sqlfluff", "pg_format" },
				hyprlang = { "shfmt" }, -- best effort, optional
			},
			formatters = {
				fish_indent = {
					command = "fish_indent",
					args = { "--write", "-" },
					stdin = true,
				},
				shfmt = {
					command = "shfmt",
					args = { "-i", "2", "-ci" }, -- 2-space indent, indent case labels
					stdin = true,
				},
			},
		})
	end,
}
