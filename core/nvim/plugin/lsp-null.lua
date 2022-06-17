local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

local sca2d_diagnostics_source = {
  name = "SCA2D",
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "scad", "openscad" },
  generator = helpers.generator_factory({
    command = "sca2d",
    args = { "$FILENAME" },
    from_temp_file = true,
    format = "line", -- calls "on_output" once per line
    on_output = function(params)
      local columns = vim.split(params, ":")
      if #columns < 5 then
        return nil
      end

      put(columns)
      local code = vim.trim(columns[4])
      local data = {
        row = columns[2],
        col = columns[3],
        code = code,
        message = columns[5] .. " (" .. code .. ")",
      }
      put(data)
      return data
    end,
  }),
}

local openscad_format_source = {
  name = "OpenSCAD Format",
  method = null_ls.methods.FORMATTING,
  filetypes = { "scad", "openscad" },
  generator = helpers.formatter_factory({
    command = "openscad-format",
    args = { "--dry" },
    to_stdin = true,
  }),
}

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua.with({
      extra_args = {
        "--config-path",
        vim.fn.expand("$DOTF/core/nvim/stylua.toml"),
      },
    }),
    null_ls.builtins.formatting.shfmt.with({
      extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
    }),
    sca2d_diagnostics_source,
    openscad_format_source,
  },
})
