-- ------------------------------------------------------------------------------
-- Comment.nvim (numToStr/Comment.nvim) — Toggle line and block comments
-- ------------------------------------------------------------------------------
-- What it does: Comment/uncomment lines or blocks with gcc, gbc, gc{motion}.
--   Works in normal, visual, and operator-pending modes.
-- Keymaps: gcc (line), gbc (block), gc/gb + motion, gco gcO gcA (extra).
-- Notes: Padding and sticky options in setup; filetype-aware.
-- ------------------------------------------------------------------------------

return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local comment = require("Comment")

		comment.setup({
			padding = true, -- Add space between comment delimiters and code
			sticky = true, -- Keep cursor at its position after commenting

			-- Keybindings to toggle comments
			toggler = {
				line = "gcc", -- Toggle line comment
				block = "gbc", -- Toggle block comment
			},

			-- Operator-pending (e.g., `gc{motion}`)
			opleader = {
				line = "gc",
				block = "gb",
			},

			-- Additional mappings
			extra = {
				above = "gco", -- Add comment on the line above
				below = "gcO", -- Add comment on the line below
				eol = "gcA", -- Add comment at end of line
			},

			-- Disable default mappings if needed (can be true/false or table)
			mappings = {
				basic = true, -- Enables gcc, gbc, gc{motion}, etc.
				extra = true, -- Enables gco, gcO, gcA
				extended = false, -- Includes `g>` and `g<` for block comment movement
			},

			-- Ignore lines that match this pattern (e.g. to skip empty lines)
			ignore = "", -- string or function(line) -> boolean

			-- Hooks (optional)
			pre_hook = function()
				return ""
			end, -- Called before commenting
			post_hook = function() end, -- Called before commenting
		})
	end,
}
