-- ------------------------------------------------------------------------------
-- nvim-dap + nvim-dap-ui — Debugger (Python via debugpy)
-- ------------------------------------------------------------------------------
-- What it does: Debug Adapter Protocol client with a panel UI (scopes, watches,
--   stack, breakpoints, REPL) and inline variable values. Reads a repo's
--   .vscode/launch.json so VS Code debug configs work unchanged.
-- Keymaps (all under <leader>d):
--   db toggle breakpoint   dB conditional bp   dc continue/start   dn step over
--   di step into           do step out         dr REPL             dl run last
--   du toggle UI           de evaluate (n/v)   dx terminate
-- Notes: debugpy is installed by Mason (mason.lua). pythonPath prefers the
--   active virtualenv ($VIRTUAL_ENV) so project deps resolve.
-- ------------------------------------------------------------------------------

local function python_path()
	local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
	if venv then
		return venv .. "/bin/python"
	end
	return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
end

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
			config = function()
				local dap, dapui = require("dap"), require("dapui")
				dapui.setup({
					layouts = {
						{
							elements = {
								{ id = "scopes", size = 0.35 },
								{ id = "breakpoints", size = 0.15 },
								{ id = "stacks", size = 0.30 },
								{ id = "watches", size = 0.20 },
							},
							size = 40,
							position = "left",
						},
						{
							elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
							size = 12,
							position = "bottom",
						},
					},
				})
				dap.listeners.after.event_initialized["dapui"] = function()
					dapui.open()
				end
				dap.listeners.before.event_exited["dapui"] = function(_, body)
					if body and body.exitCode == 0 then
						dapui.close()
					end
				end
			end,
		},
		{ "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
	},
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "DAP: toggle breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "DAP: conditional breakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "DAP: continue / start",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "DAP: step over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "DAP: step into",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "DAP: step out",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "DAP: REPL",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "DAP: run last",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "DAP: toggle UI",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			mode = { "n", "v" },
			desc = "DAP: evaluate",
		},
		{
			"<leader>dx",
			function()
				require("dap").terminate()
			end,
			desc = "DAP: terminate",
		},
	},
	config = function()
		local dap = require("dap")

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

		-- Python (debugpy from Mason)
		dap.adapters.python = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
			args = { "-m", "debugpy.adapter" },
		}
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = python_path,
			},
			{
				type = "python",
				request = "launch",
				name = "Launch file with args",
				program = "${file}",
				args = function()
					return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
				end,
				pythonPath = python_path,
			},
			{
				type = "python",
				request = "launch",
				name = "pytest: current file",
				module = "pytest",
				args = { "${file}" },
				pythonPath = python_path,
			},
		}

		-- VS Code parity: pick up .vscode/launch.json if the repo has one
		pcall(function()
			require("dap.ext.vscode").load_launchjs(nil, { python = { "python" } })
		end)
	end,
}
