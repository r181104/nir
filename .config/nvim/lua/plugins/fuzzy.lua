return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			winopts = {
				height = 0.9,
				width = 0.9,
				border = "rounded",
				preview = {
					vertical = "down:40%",
					horizontal = "right:30%",
					layout = "horizontal",
					hidden = false,
				},
			},
			keymap = {
				fzf = {
					["tab"] = "down",
					["shift-tab"] = "up",
					["ctrl-p"] = "toggle-preview",
				},
			},
		})
	end,
}
