return {
  {
    -- Debug Framework
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      require 'configs.nvim-dap'
    end,
    event = 'VeryLazy',
  },
  { 'nvim-neotest/nvim-nio' },
  {
    -- UI for debugging
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      require 'configs.nvim-dap-ui'
    end,
  },
}
