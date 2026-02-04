return {
	name = "nvim-lint",
	dir = "@nvim_lint@",
	event = { "BufWritePost" },
	config = function()
		local lint = require("lint")

		lint.linters.textlint = {
			cmd = "textlint",
			stdin = true,
			args = {
				"--format",
				"compact",
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			},
			ignore_exitcode = true,
			stream = "stdout",
			parser = require("lint.parser").from_errorformat("%f: line %l\\, col %c\\, %m", {
				source = "textlint",
				severity = vim.diagnostic.severity.WARN,
			}),
		}

		lint.linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			python = { "ruff" },
			haskell = { "hlint" },
			terraform = { "tflint" },
			nix = { "statix", "deadnix" },
			lua = { "selene" },
			yaml = { "actionlint" },
			c = { "clangtidy" },
			cpp = { "clangtidy" },
			css = { "stylelint" },
			scss = { "stylelint" },
			less = { "stylelint" },
			markdown = { "markdownlint-cli2", "textlint" },
			typescript = { "deno", "oxlint" },
			typescriptreact = { "deno", "oxlint" },
			javascript = { "deno", "oxlint" },
			javascriptreact = { "deno", "oxlint" },
			-- clippy is configured via rust-analyzer in lsp.lua
			-- rust = { "clippy" },
		}

		-- Use deno linter for Deno projects, oxlint for Node.js projects
		local function is_deno_project()
			return vim.fs.find({ "deno.json", "deno.jsonc" }, {
				path = vim.fn.expand("%:p:h"),
				upward = true,
			})[1] ~= nil
		end

		local linter_conditions = {
			deno = is_deno_project,
			oxlint = function()
				return not is_deno_project()
			end,
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				local ft = vim.bo.filetype
				local linters = lint.linters_by_ft[ft] or {}
				local active_linters = vim.tbl_filter(function(name)
					local cond = linter_conditions[name]
					return cond == nil or cond()
				end, linters)
				for _, linter in ipairs(active_linters) do
					lint.try_lint(linter)
				end
			end,
		})
	end,
}
