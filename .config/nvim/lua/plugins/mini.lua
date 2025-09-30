return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		-- ===== Basics =====
		require("mini.basics").setup({
			options = { basic = true, extra_ui = true, win_borders = "default" },
			mappings = { basic = false, option_toggle_prefix = "", windows = false, move_with_alt = false },
			autocommands = { basic = true, relnum_in_visual_mode = true },
		})
		-- ===== Comment =====
		require("mini.comment").setup({ mappings = { comment = "", comment_line = "" } })
		vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
		vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })
		-- ===== Pairs & Surround =====
		require("mini.pairs").setup()
		require("mini.surround").setup({
			mappings = {
				add = "",
				delete = "",
				find = "",
				find_left = "",
				highlight = "",
				replace = "",
				update_n_lines = "",
			},
		})
		vim.keymap.set("n", "<leader>sa", "<Plug>(mini-surround-add)", { desc = "Add surround" })
		vim.keymap.set("n", "<leader>sd", "<Plug>(mini-surround-delete)", { desc = "Delete surround" })
		vim.keymap.set("n", "<leader>sr", "<Plug>(mini-surround-replace)", { desc = "Replace surround" })
		-- ===== AI & Operators =====
		require("mini.ai").setup()
		require("mini.operators").setup({ mappings = false })
		vim.keymap.set("n", "gx", "<Plug>(mini-operators-exchange)", { desc = "Exchange" })
		vim.keymap.set("n", "gs", "<Plug>(mini-operators-sort)", { desc = "Sort" })
		vim.keymap.set("n", "gD", "<Plug>(mini-operators-duplicate)", { desc = "Duplicate" })
		-- ===== Jump2d =====
		require("mini.jump2d").setup()
		vim.keymap.set("n", "<leader>j", function()
			MiniJump2d.start()
		end, { desc = "Jump2d" })
		-- ===== Files =====
		require("mini.files").setup({
			mappings = {
				go_in = "",
				go_out = "",
				close = "",
				go_split = "",
				go_vsplit = "",
				go_tab = "",
				create = "",
				remove = "",
				rename = "",
				copy = "",
				move = "",
				toggle_hidden = "",
			},
			use_as_default_explorer = true,
		})
		local mf = require("mini.files")
		mf.setup({
			mappings = {},
			use_as_default_explorer = true,
		})
		vim.keymap.set("n", "<leader>e", mf.open, { desc = "File Explorer" })
		mf.open = (function(original_open)
			return function(...)
				original_open(...)
				local buf = vim.api.nvim_get_current_buf()
				local map = function(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
				end
				map("<CR>", mf.go_in, "Open file/folder")
				map("h", mf.go_out, "Go up folder")
				map("l", mf.go_in, "Enter folder")
				map("q", mf.close, "Close explorer")
				map("v", mf.go_vsplit, "Open in vertical split")
				map("s", mf.go_split, "Open in horizontal split")
				map("t", mf.go_tab, "Open in new tab")
				map("a", mf.create, "Create file/folder")
				map("d", mf.remove, "Delete file/folder")
				map("r", mf.rename, "Rename file/folder")
				map("c", mf.copy, "Copy file/folder")
				map("m", mf.move, "Move file/folder")
				map(".", mf.toggle_hidden, "Toggle hidden files")
			end
		end)(mf.open)
		-- ===== Pick & Extra =====
		require("mini.pick").setup()
		require("mini.extra").setup()
		-- Custom Find/Grep/Buffers keymaps
		local pick = require("mini.pick")
		vim.keymap.set("n", "<leader>ff", function()
			pick.builtin.files({
				prompt = "Find Files> ",
				previewer = "builtin",
				cwd = vim.loop.cwd(),
			})
		end, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fh", function()
			pick.builtin.grep_live({
				prompt = "Live Grep> ",
				search_cmd = "rg --vimgrep --smart-case",
				cwd = vim.loop.cwd(),
			})
		end, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>fb", function()
			pick.builtin.buffers({
				prompt = "Buffers> ",
				previewer = "builtin",
			})
		end, { desc = "Buffers" })
		-- ===== Indents, Highlight =====
		require("mini.indentscope").setup()
		require("mini.hipatterns").setup({
			highlighters = { hex_color = require("mini.hipatterns").gen_highlighter.hex_color() },
		})
		-- ===== Statusline =====
		local statusline = require("mini.statusline")
		local function lsp_status()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients > 0 then
				local names = {}
				for _, c in ipairs(clients) do
					table.insert(names, c.name)
				end
				return "%#MiniStatuslineLspOn# " .. table.concat(names, ",") .. "%*"
			else
				return "%#MiniStatuslineLspOff# off%*"
			end
		end
		vim.api.nvim_set_hl(0, "MiniStatuslineLspOn", { fg = "#a6e3a1", bg = "#1e1e2e", bold = true })
		vim.api.nvim_set_hl(0, "MiniStatuslineLspOff", { fg = "#f38ba8", bg = "#1e1e2e" })
		statusline.setup({
			use_icons = true,
			content = {
				active = function()
					local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
					local git = statusline.section_git({ trunc_width = 75 })
					local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
					local filename = statusline.section_filename({ trunc_width = 140 })
					local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
					local location = statusline.section_location({ trunc_width = 75 })

					return statusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics, lsp_status() } },
						"%<",
						{ hl = "MiniStatuslineFilename", strings = { filename } },
						"%=",
						{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
						{ hl = mode_hl, strings = { location } },
					})
				end,
			},
		})
	end,
}
