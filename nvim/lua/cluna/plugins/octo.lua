-- ------------------------------------------------------------------------------
-- octo.nvim (pwntester/octo.nvim) — GitHub PR and issue review in Neovim
-- ------------------------------------------------------------------------------
-- What it does: Opens PRs and issues as editable Neovim buffers. Inline review
--   comments, approve/request-changes, merge, and issue management — no browser.
--   Requires `gh` CLI authenticated (gh auth status).
-- Keymaps: <leader>go (PR list), <leader>gi (issue list), <leader>gR (review).
--   Inside PR buffers: <leader>p* for PR actions, <leader>i* for issue actions.
-- Notes: Works on current repo (reads git remote). gh must be on PATH.
-- ------------------------------------------------------------------------------

return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "Octo",
	keys = {
		{ "<leader>go", "<cmd>Octo pr list<CR>", desc = "Octo: list PRs" },
		{ "<leader>gi", "<cmd>Octo issue list<CR>", desc = "Octo: list issues" },
		{ "<leader>gR", "<cmd>Octo review start<CR>", desc = "Octo: start review" },
	},
	opts = {
		default_remote = { "upstream", "origin" },
		snippet_context_lines = 4,
		file_panel = { size = 10, icons = true },
		gh_env = {},
		mappings = {
			issue = {
				close_issue = { lhs = "<leader>ix", desc = "close issue" },
				reopen_issue = { lhs = "<leader>io", desc = "reopen issue" },
				list_issues = { lhs = "<leader>il", desc = "list issues on repo" },
				add_assignee = { lhs = "<leader>ia", desc = "add assignee" },
				add_label = { lhs = "<leader>iL", desc = "add label" },
				copy_url = { lhs = "<leader>iu", desc = "copy URL" },
				open_in_browser = { lhs = "<leader>ib", desc = "open in browser" },
			},
			pull_request = {
				checkout_pr = { lhs = "<leader>po", desc = "checkout PR" },
				merge_pr = { lhs = "<leader>pm", desc = "merge PR" },
				squash_and_merge_pr = { lhs = "<leader>pM", desc = "squash and merge" },
				list_commits = { lhs = "<leader>pc", desc = "list commits" },
				list_changed_files = { lhs = "<leader>pf", desc = "list changed files" },
				show_pr_diff = { lhs = "<leader>pd", desc = "show diff" },
				add_reviewer = { lhs = "<leader>pv", desc = "add reviewer" },
				remove_reviewer = { lhs = "<leader>pV", desc = "remove reviewer" },
				close_pr = { lhs = "<leader>px", desc = "close PR" },
				reopen_pr = { lhs = "<leader>pO", desc = "reopen PR" },
				copy_url = { lhs = "<leader>pu", desc = "copy URL" },
				open_in_browser = { lhs = "<leader>pb", desc = "open in browser" },
			},
			review_thread = {
				add_comment = { lhs = "<space>ca", desc = "add comment" },
				add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
				delete_comment = { lhs = "<space>cd", desc = "delete comment" },
				submit_review = { lhs = "<space>vs", desc = "submit review" },
				approve_review = { lhs = "<space>va", desc = "approve" },
				request_changes = { lhs = "<space>vr", desc = "request changes" },
				close_review = { lhs = "<space>vx", desc = "close review" },
			},
		},
	},
}
