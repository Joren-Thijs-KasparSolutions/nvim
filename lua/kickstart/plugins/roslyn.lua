return {
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for Roslyn.
        'tris203/rzls.nvim',
        branch = 'pullDiags',
        config = true,
      },
    },
    config = function()
      local mason_registry = require 'mason-registry'

      ---@type string[]
      local cmd = {}

      local roslyn_package = mason_registry.get_package 'roslyn'
      if roslyn_package:is_installed() then
        vim.list_extend(cmd, {
          'roslyn',
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
        })

        local rzls_package = mason_registry.get_package 'rzls'
        if rzls_package:is_installed() then
          local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec'
          table.insert(cmd, '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'))
          table.insert(cmd, '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'))
        end
      end

      require('roslyn').setup {
        cmd = cmd,
        handlers = require 'rzls.roslyn_handlers',
        settings = {
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      }
    end,
    init = function()
      -- We add the Razor file types before the plugin loads.
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
  },
}
