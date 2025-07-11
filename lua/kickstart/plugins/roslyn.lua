return {
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
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
      -- We also must configure the roslyn.nvim plugin to communicate with the rzls.
      -- To do so, you must pass the handlers defined in the rzls.roslyn_handlers module and adjust the CLI command that Roslyn uses.
      -- To configure roslyn.nvim, we need to compose a shell command string with arguments for it.
      -- Some of these arguments are CLI-options relating to rzls. We can compose the command as follows with mason
      local mason_registry = require 'mason-registry'

      ---@type string[]
      local cmd = {}

      local roslyn_package = mason_registry.get_package 'roslyn'
      local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec'
      if roslyn_package:is_installed() then
        vim.list_extend(cmd, {
          'roslyn',
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
        })

        local rzls_package = mason_registry.get_package 'rzls'
        if rzls_package:is_installed() then
          table.insert(cmd, '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'))
          table.insert(cmd, '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'))

          vim.list_extend(cmd, {
            '--extension',
            '/Users/jorenthijs/.vscode/extensions/ms-dotnettools.csharp-2.76.23-darwin-arm64/.razorExtension/Microsoft.VisualStudioCode.RazorExtension.dll',
          })
        end
      end
      vim.print(vim.inspect(cmd))
      require('roslyn').setup {
        cmd = {
          'roslyn',
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
          '--extension',
          '/Users/jorenthijs/.vscode/extensions/ms-dotnettools.csharp-2.76.23-darwin-arm64/.razorExtension/Microsoft.VisualStudioCode.RazorExtension.dll',
          -- '--stdio',
        },
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
