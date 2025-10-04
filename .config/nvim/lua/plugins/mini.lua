return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		-- ===== Basics =====
		require("mini.basics").setup({
			options = {
				basic = true,
				extra_ui = true,
				win_borders = "single",
			},
			mappings = {
				basic = true,
				option_toggle_prefix = "<leader>o",
				windows = true,
				move_with_alt = true,
			},
			autocommands = { basic = true, relnum_in_visual_mode = true },
		})

		-- ===== Comment =====
		local comment = require("mini.comment")
		comment.setup({
			mappings = {
				comment = "<leader>/",
				comment_line = "<leader>c",
			},
		})

		-- ===== Pairs =====
		require("mini.pairs").setup({})

		-- ===== AI & Operators =====
		require("mini.ai").setup({
			n_lines = 500,
			custom_textobjects = nil,
		})
		local operators = require("mini.operators")
		operators.setup({ mappings = true })

		vim.keymap.set("n", "gx", "<Plug>(mini-operators-exchange)", { desc = "Exchange" })
		vim.keymap.set("n", "gs", "<Plug>(mini-operators-sort)", { desc = "Sort" })
		vim.keymap.set("n", "gD", "<Plug>(mini-operators-duplicate)", { desc = "Duplicate" })

		-- ===== Jump2d =====
		local jump2d = require("mini.jump2d")
		jump2d.setup()
		vim.keymap.set("n", "<leader>j", function()
			jump2d.start()
		end, { desc = "Jump2d" })

		-- ===== Pick & Extra =====
		local pick = require("mini.pick")
		pick.setup()
		require("mini.extra").setup()

		vim.keymap.set("n", "<leader>ff", function()
			pick.builtin.files({ prompt = "Find Files> ", previewer = "builtin", cwd = vim.loop.cwd() })
		end, { desc = "Find files" })

		vim.keymap.set("n", "<leader>fh", function()
			pick.builtin.grep_live({
				prompt = "Live Grep> ",
				search_cmd = "rg --vimgrep --smart-case",
				cwd = vim.loop.cwd(),
			})
		end, { desc = "Live grep" })

		vim.keymap.set("n", "<leader>fb", function()
			pick.builtin.buffers({ prompt = "Buffers> ", previewer = "builtin" })
		end, { desc = "Buffers" })

		vim.keymap.set("n", "<leader>fp", function()
			pick.builtin.help({ prompt = "Help> ", previewer = "builtin" })
		end, { desc = "Help tags" })

		-- ===== Indents & Highlight =====
		require("mini.indentscope").setup({
			draw = {
				delay = 100,
				animation = function()
					return 0
				end,
			},
			symbol = "│",
		})

		require("mini.hipatterns").setup({
			highlighters = {
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
				fixme = { pattern = "%f[%w](TODO|FIXME|BUG):", group = "Todo" },
			},
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

		-- ===== Extra: Visual Enhancements =====
		vim.cmd([[hi MiniIndentscopeSymbol guifg=#89b4fa]])
		vim.cmd([[hi MiniPickPrompt guifg=#f5c2e7]])
		vim.cmd([[hi MiniStatuslineDevinfo guifg=#89b4fa]])
		vim.cmd([[hi MiniStatuslineFilename guifg=#f38ba8]])
		vim.cmd([[hi MiniStatuslineFileinfo guifg=#cba6f7]])
	end,
}
