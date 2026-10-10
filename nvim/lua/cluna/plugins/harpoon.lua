-- ------------------------------------------------------------------------------
-- harpoon (ThePrimeagen/harpoon, harpoon2 branch) — Pin files, jump by number
-- ------------------------------------------------------------------------------
-- What it does: Mark the files you're working on and jump between them with
--   one key. Marks are per project (cwd).
-- Keymaps: <leader>aa add file · <leader>1-4 jump to mark · <leader>am menu
-- ------------------------------------------------------------------------------

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>aa",
			function()
				require("harpoon"):list():add()
			end,
			desc = "Harpoon: add file",
		},
		{
			"<leader>am",
			function()
				local h = require("harpoon")
				h.ui:toggle_quick_menu(h:list())
			end,
			desc = "Harpoon: menu",
		},
		{
			"<leader>1",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Harpoon: file 1",
		},
		{
			"<leader>2",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Harpoon: file 2",
		},
		{
			"<leader>3",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Harpoon: file 3",
		},
		{
			"<leader>4",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "Harpoon: file 4",
		},
	},
	config = function()
		require("harpoon"):setup()
	end,
}
