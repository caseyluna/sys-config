-- ------------------------------------------------------------------------------
-- neotest (nvim-neotest/neotest) — Test runner (pytest)
-- ------------------------------------------------------------------------------
-- What it does: Runs tests in the background, marks pass/fail in the gutter,
--   shows output in a split, and can debug a test with nvim-dap.
-- Keymaps (all under <leader>T):
--   Tr run nearest   TT run file   Ts summary   To output   TO output panel
--   Td debug nearest TX stop
-- Notes: Adapter list is where new languages go.
-- ------------------------------------------------------------------------------

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
	},
	keys = {
		{
			"<leader>Tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Test: run nearest",
		},
		{
			"<leader>TT",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Test: run file",
		},
		{
			"<leader>Ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Test: summary",
		},
		{
			"<leader>To",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Test: output",
		},
		{
			"<leader>TO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Test: output panel",
		},
		{
			"<leader>Td",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Test: debug nearest",
		},
		{
			"<leader>Tx",
			function()
				require("neotest").run.stop()
			end,
			desc = "Test: stop",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({ dap = { justMyCode = false }, runner = "pytest" }),
			},
			diagnostic = { enabled = true, severity = vim.diagnostic.severity.ERROR },
			icons = {
				passed = "✓",
				failed = "✗",
				running = "◌",
				skipped = "○",
				unknown = "?",
				watching = "◎",
			},
			output = { open_on_run = false },
		})
	end,
}
