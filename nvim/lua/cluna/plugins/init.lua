-- ------------------------------------------------------------------------------
-- plugins/init.lua — Shared plugin dependencies (loaded first by lazy.nvim)
-- ------------------------------------------------------------------------------
-- Libraries many plugins depend on. Add real plugins as their own file in this
-- directory, not here.
-- ------------------------------------------------------------------------------

return {
	"nvim-lua/plenary.nvim", -- Lua utility library (telescope, neotest, octo, …)
	"nvim-tree/nvim-web-devicons", -- file icons (requires a Nerd Font)
}
