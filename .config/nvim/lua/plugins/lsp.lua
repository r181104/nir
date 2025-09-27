return {
	"neovim/nvim-lspconfig",
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local has_blink, blink_cmp = pcall(require, "blink.cmp")
		if has_blink then
			capabilities = blink_cmp.get_lsp_capabilities(capabilities)
		end

		local function on_attach(client, bufnr) end

		vim.lsp.config("*", {
			capabilities = capabilities,
			on_attach = on_attach,
			root_markers = { ".git", "package.json", "pyproject.toml" },
		})
		-- NOTE: Lua
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false,
					},
				},
			},
			root_dir = function(fname)
				return vim.lsp.util.root_pattern("lua_ls.toml", ".git")(fname) or vim.loop.cwd()
			end,
		})
		-- NOTE: Python
		vim.lsp.config("pyright", {})
		-- NOTE: Java (jdtls)
		vim.lsp.config("jdtls", {
			cmd = { "jdtls" },
		})
		-- NOTE: Rust
		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					cargo = { allFeatures = true },
					checkOnSave = { command = "clippy" },
				},
			},
		})
		-- NOTE: TypeScript / JS via vtsls
		vim.lsp.config("vtsls", {})
		-- NOTE: Tailwind CSS
		vim.lsp.config("tailwindcss", {})
		-- NOTE: Finally, enable all those servers
		vim.lsp.enable({
			"lua_ls",
			"pyright",
            "clangd",
			"jdtls",
			"rust_analyzer",
			"vtsls",
			"tailwindcss",
		})
	end,
}
