return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"leoluz/nvim-dap-go",
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<leader>dsi",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<leader>dsO",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<leader>dso",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Set Breakpoint",
		},
		{
			"<leader>Db",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Set Conditional Breakpoint",
		},
		{
			"<leader>Du",
			function()
				require("dap").toggle()
			end,
			desc = "Debug: Toggle UI",
		},
		{
			"<leader>Dl",
			function()
				require("dap").run_last()
			end,
			desc = "Debug: Run Last Configuration",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		-- Dap UI setup
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})
		-- Automatically open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Setup virtual text to show variable values inline
		require("nvim-dap-virtual-text").setup()

		require("dap-go").setup({
			delve = {
				-- Use Mason's delve installation with fallback to system delve
				path = function()
					local mason_delve = vim.fn.stdpath("data") .. "/mason/bin/dlv"
					if vim.fn.executable(mason_delve) == 1 then
						return mason_delve
					end
					-- Fallback to system delve
					return vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "dlv"
				end,
			},
		})
	end,
}
