return {
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',

      'andymass/vim-matchup',          -- for enhanced % motion behavior
      'andrewradev/switch.vim',        -- for switch support
      'tomtom/tcomment_vim',           -- for commenting
      'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers
      'hrsh7th/nvim-cmp',              -- for completion
    },

    opts = {
      mappings = true,
    },
  },
}
