-- ------------------------------------------------------------------------------
-- nvim-surround (kylechui/nvim-surround) — Add/change/delete surroundings
-- ------------------------------------------------------------------------------
-- What it does: Add (ys), change (cs), or delete (ds) surrounding chars: quotes,
--   brackets, tags. E.g. ysiw", cs"', ds". Works in normal, visual, operator.
-- Keymaps: ysiw + char, cs + old + new, ds + char (default keymaps).
-- Notes: config = true uses defaults; override with a setup function if needed.
-- ------------------------------------------------------------------------------

return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*", -- Use the latest stable release
	config = true, -- Uses default configuration; set to a function for custom setup
}
