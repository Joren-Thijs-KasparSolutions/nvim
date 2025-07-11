return {
  {
    'nvim-neotest/neotest',
    requires = {
      {
        'Issafalcon/neotest-dotnet',
      },
    },
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'Issafalcon/neotest-dotnet',
    lazy = false,
    dependencies = {
      'nvim-neotest/neotest',
    },
  },
}
