vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("lazy").update({ show = false })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(ev)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		-- NOTE: LSP core
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "Find references")
		map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "K", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
		-- NOTE: Workspace
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List workspace folders")
		map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Search workspace symbols")
		-- NOTE: Actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>for", function()
			vim.lsp.buf.format({ async = true })
		end, "Format buffer")
		-- NOTE: Diagnostics
		map("n", "<leader>fe", vim.diagnostic.open_float, "Show diagnostics in float")
		map("n", "<leader>ce", vim.diagnostic.setqflist, "Send diagnostics to quickfix")
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})

-- Create a custom command :LiveServer
vim.api.nvim_create_user_command("LiveServer", function()
	local cwd = vim.fn.getcwd()
	vim.fn.jobstart({ "live-server", "--port=8000", "--no-browser", cwd }, { detach = true })
	print("🚀 Live Server born at http://localhost:8000")
end, {})

vim.api.nvim_create_user_command("LiveServerStop", function()
	vim.fn.system("pkill -f live-server")
	print("🛑 Live Server killed")
end, {})

vim.api.nvim_create_user_command("PyServer", function()
	local cwd = vim.fn.getcwd()
	vim.fn.jobstart({ "python", "-m", "http.server", "8000", "--directory", cwd }, { detach = true })
	print("🚀 Python HTTP Server born at http://localhost:8000")
end, {})

vim.api.nvim_create_user_command("PyServerStop", function()
	vim.fn.system("pkill -f 'python -m http.server'")
	print("🛑 Python HTTP Server killed")
end, {})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
-- })
