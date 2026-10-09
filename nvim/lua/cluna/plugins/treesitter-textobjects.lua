-- ------------------------------------------------------------------------------
-- nvim-treesitter-textobjects (nvim-treesitter/nvim-treesitter-textobjects)
-- ------------------------------------------------------------------------------
-- What it does: Text objects and moves for function, class, block (e.g. ]f [f
--   for next/prev function, vaf for "around function"). Uses Treesitter.
-- Keymaps: ]f [f (function), ]c [c (class), etc. No conflict with ]d [d (diagnostics).
-- Notes: master branch — configured through nvim-treesitter.configs (the
--   module itself has no setup()).
-- ------------------------------------------------------------------------------

return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "master",
	event = "BufReadPre",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function(_, opts)
		require("nvim-treesitter.configs").setup({ textobjects = opts })
	end,
	opts = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = { query = "@function.outer", desc = "Around function" },
				["if"] = { query = "@function.inner", desc = "Inner function" },
				["ac"] = { query = "@class.outer", desc = "Around class" },
				["ic"] = { query = "@class.inner", desc = "Inner class" },
				["ab"] = { query = "@block.outer", desc = "Around block" },
				["ib"] = { query = "@block.inner", desc = "Inner block" },
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
		},
	},
}
