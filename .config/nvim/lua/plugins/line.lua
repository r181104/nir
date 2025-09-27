return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		-- Custom component to show active LSP(s)
		local function lsp_name()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if not clients or #clients == 0 then
				return "" -- nothing if no LSP
			end
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			return "  " .. table.concat(names, ", ")
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				icons_enabled = true,
			},
			sections = {
				lualine_a = { { "mode", icon = "" } },
				lualine_b = {
					{ "branch", icon = "" },
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
					},
				},
				lualine_c = {
					{
						"filename",
						path = 0, -- only filename, no path
						symbols = { modified = " ", readonly = " " },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
				},
				lualine_x = {
					{ lsp_name }, -- ✅ now reliable
					{ "encoding" },
					{ "fileformat", symbols = { unix = "", dos = "", mac = "" } },
					{ "filetype" },
				},
				lualine_y = { "progress" },
				lualine_z = {
					{ "location" },
					{
						function()
							return " " .. os.date("%H:%M")
						end,
					},
				},
			},
			extensions = { "fugitive", "oil", "lazy", "toggleterm" },
		})
	end,
}
