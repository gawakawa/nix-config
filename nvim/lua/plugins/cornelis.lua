return {
	"isovector/cornelis",
	name = "cornelis",
	ft = "agda",
	build = "stack install",
	dependencies = {
		"neovimhaskell/nvim-hs.vim",
		"kana/vim-textobj-user",
	},
	version = "*",
	keys = {
		{ "<C-c><C-l>", "<cmd>CornelisLoad<cr>", ft = "agda", desc = "Load" },
		{ "<C-c><C-d>", "<cmd>CornelisTypeInfer<cr>", ft = "agda", desc = "Type infer" },
		{ "<C-c><C-t>", "<cmd>CornelisTypeContext<cr>", ft = "agda", desc = "Type context" },
		{ "<C-c><C-r>", "<cmd>CornelisRefine<cr>", ft = "agda", desc = "Refine" },
		{ "<C-c><C-space>", "<cmd>CornelisGive<cr>", ft = "agda", desc = "Give" },
		{ "<C-c><C-c>", "<cmd>CornelisMakeCase<cr>", ft = "agda", desc = "Case split" },
		{ "<C-c><C-a>", "<cmd>CornelisAuto<cr>", ft = "agda", desc = "Auto" },
		{ "<C-c><C-n>", "<cmd>CornelisNormalize<cr>", ft = "agda", desc = "Normalize" },
		{ "<C-c><C-?>", "<cmd>CornelisGoals<cr>", ft = "agda", desc = "Goals" },
	},
}
