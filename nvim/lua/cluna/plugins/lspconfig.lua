-- ------------------------------------------------------------------------------
-- nvim-lspconfig (neovim/nvim-lspconfig) — LSP servers for the languages we use
-- ------------------------------------------------------------------------------
-- What it does: Registers server configs with vim.lsp.config (Neovim 0.11+) and
--   enables each one. Servers are installed by Mason (mason.lua) — keep the two
--   lists in sync. Diagnostics UI (signs, virtual text, float) is set here too.
-- Keymaps (buffer-local, on LspAttach):
--   gd gi gt gR        definitions / implementations / type defs / references (Telescope)
--   K                  hover            gl   line diagnostics (float)
--   [d ]d              prev/next diagnostic
--   <leader>ca         code action      <leader>rn  rename (inline preview)
--   <leader>rs         restart LSP      <leader>uh  toggle inlay hints
-- Notes: Completion capabilities come from blink.cmp (blink.lua).
-- ------------------------------------------------------------------------------

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "folke/lazydev.nvim", ft = "lua", opts = {} }, -- lua_ls knows the nvim API
		{ "antosha417/nvim-lsp-file-operations", config = true }, -- rename imports on file move (neo-tree)
	},
	config = function()
		-- ----------------------------------------------------------------------
		-- Diagnostics appearance
		-- ----------------------------------------------------------------------
		vim.diagnostic.config({
			severity_sort = true,
			virtual_text = { spacing = 2, prefix = "●" },
			float = { border = "rounded", source = "if_many" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		-- ----------------------------------------------------------------------
		-- Capabilities shared by every server (completion from blink.cmp)
		-- ----------------------------------------------------------------------
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok_blink, blink = pcall(require, "blink.cmp")
		if ok_blink then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end
		local ok_ops, lsp_file_ops = pcall(require, "lsp-file-operations")
		if ok_ops then
			capabilities = vim.tbl_deep_extend("force", capabilities, lsp_file_ops.default_capabilities())
		end
		vim.lsp.config("*", { capabilities = capabilities })

		-- ----------------------------------------------------------------------
		-- Keymaps on attach (buffer-local)
		-- ----------------------------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("cluna_lsp_attach", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
				end

				map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "LSP: definitions")
				map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "LSP: implementations")
				map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "LSP: type definitions")
				map("n", "gR", "<cmd>Telescope lsp_references<CR>", "LSP: references")
				map("n", "K", vim.lsp.buf.hover, "LSP: hover")
				map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
				map("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, "Previous diagnostic")
				map("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, "Next diagnostic")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("n", "<leader>rn", function()
					if pcall(require, "inc_rename") then
						vim.cmd("IncRename " .. vim.fn.expand("<cword>"))
					else
						vim.lsp.buf.rename()
					end
				end, "Rename symbol")
				map("n", "<leader>rs", "<cmd>LspRestart<CR>", "Restart LSP")

				-- Inlay hints: native (replaces lsp-inlayhints.nvim); on by default when supported
				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
				end
				map("n", "<leader>uh", function()
					local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
					vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
				end, "Toggle inlay hints")
			end,
		})

		-- ----------------------------------------------------------------------
		-- Servers (installed by Mason — see mason.lua). Keys = lspconfig names.
		-- ----------------------------------------------------------------------
		local servers = {
			-- Python: pyright for types/navigation, ruff for lint + import sorting + fixes
			pyright = {
				settings = { python = { analysis = { typeCheckingMode = "basic" } } },
			},
			ruff = {},
			-- Lua (this config)
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						workspace = { checkThirdParty = false },
					},
				},
			},
			-- Shell
			bashls = { filetypes = { "sh", "bash", "zsh" } },
			-- Infra / config
			terraformls = {},
			dockerls = {},
			yamlls = {},
			jsonls = {},
			taplo = {}, -- TOML
			-- Data
			sqlls = {},
			-- Docs / web
			marksman = {}, -- Markdown
			html = {},
			cssls = {},
		}

		for name, cfg in pairs(servers) do
			vim.lsp.config(name, cfg)
			vim.lsp.enable(name)
		end
	end,
}
