-- ------------------------------------------------------------------------------
-- blink.cmp (saghen/blink.cmp) — Completion engine (LSP, snippets, path, buffer,
-- Copilot) with built-in signature help and cmdline completion
-- ------------------------------------------------------------------------------
-- What it does: Replaces nvim-cmp + its sources. Rust fuzzy matcher, LSP
--   capabilities are passed to servers in lspconfig.lua.
-- Keymaps (insert):
--   <C-j>/<C-k>  next/prev item      <CR>  accept        <C-e>  hide
--   <C-Space>    open menu / docs    <C-b>/<C-f>  scroll docs
--   <Tab>/<S-Tab> snippet jump forward/back (only when a snippet is active)
-- Notes: Copilot appears as a source (copilot.lua). Snippets from LuaSnip +
--   friendly-snippets. Signature help pops up while typing call arguments.
-- ------------------------------------------------------------------------------

return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		"fang2hou/blink-copilot",
	},
	opts = {
		keymap = {
			preset = "default",
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		snippets = { preset = "luasnip" },
		completion = {
			list = { selection = { preselect = false, auto_insert = true } },
			menu = {
				border = "rounded",
				draw = {
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
				},
			},
			documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
			ghost_text = { enabled = false },
		},
		signature = { enabled = true, window = { border = "rounded" } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot", "lazydev" },
			providers = {
				copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true },
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},
		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			completion = { menu = { auto_show = true } },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
