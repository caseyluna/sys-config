-- ------------------------------------------------------------------------------
-- copilot.lua (zbirenbaum/copilot.lua) — GitHub Copilot backend
-- ------------------------------------------------------------------------------
-- What it does: Runs the Copilot language server. Suggestions surface in the
--   blink.cmp menu via blink-copilot (blink.lua); inline ghost text is off.
-- Keymaps: none (accept like any completion item). :Copilot auth to sign in.
-- Notes: Needs Node 22+ — fnm installs it (setup.sh); the helper below finds it
--   even when nvim is launched from a GUI without the shell's PATH.
-- ------------------------------------------------------------------------------

local function node_bin()
	local node = vim.fn.exepath("node")
	if node ~= "" then
		local major = tonumber((vim.fn.system({ node, "--version" }):match("v(%d+)")))
		if major and major >= 22 then
			return node
		end
	end
	local fnm_dir = vim.env.FNM_DIR or (vim.env.HOME .. "/Library/Application Support/fnm")
	for _, p in ipairs(vim.fn.glob(fnm_dir .. "/node-versions/*/installation/bin/node", true, true)) do
		local major = tonumber((vim.fn.system({ p, "--version" }):match("v(%d+)")))
		if major and major >= 22 then
			return p
		end
	end
	return "node"
end

return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		copilot_node_command = node_bin(),
		suggestion = { enabled = false },
		panel = { enabled = false },
		filetypes = { markdown = true, gitcommit = true, ["*"] = true },
	},
}
