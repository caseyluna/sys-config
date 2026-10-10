-- ------------------------------------------------------------------------------
-- lualine.nvim (nvim-lualine/lualine.nvim) — Statusline
-- ------------------------------------------------------------------------------
-- What it does: Mode, branch, diff, diagnostics, filename, pending plugin
--   updates, active LSP servers, encoding/filetype, position. Colors follow
--   the catppuccin colorscheme.
-- ------------------------------------------------------------------------------

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local lazy_status = require("lazy.status")

		-- Names of the LSP servers attached to the current buffer
		local function lsp_status()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end
			local names = {}
			for _, c in ipairs(clients) do
				table.insert(names, c.name)
			end
			return "\u{f489} " .. table.concat(names, " ")
		end

		return {
			options = {
				theme = "catppuccin",
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					{ lazy_status.updates, cond = lazy_status.has_updates, color = { fg = "#ff9e64" } },
					{ lsp_status },
					"encoding",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		}
	end,
}
