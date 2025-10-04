return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			sort_case_insensitive = true,
			default_component_configs = {
				container = { enable_character_fade = true },
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
					default = "",
				},
				modified = { symbol = "●", highlight = "NeoTreeModified" },
				name = { trailing_slash = false, use_git_status_colors = true },
				git_status = {
					symbols = {
						added = "",
						modified = "柳",
						deleted = "",
						renamed = "柳",
						untracked = "",
						ignored = "◌",
						unstaged = "✗",
						staged = "✓",
						conflict = "",
					},
				},
			},
			window = {
				position = "right",
				width = 20,
				auto_resize = true,
				mapping_options = { noremap = true, nowait = true },
				mappings = {
					["<space>"] = "toggle_node",
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["C"] = "close_node",
					["R"] = "refresh",
					["a"] = { "add", config = { show_path = "relative" } },
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["q"] = "close_window",
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			buffers = {
				follow_current_file = { enabled = true },
				group_empty_dirs = true,
				show_unloaded = true,
			},
			git_status = { window = { position = "float" } },
		})

		vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
	end,
}
