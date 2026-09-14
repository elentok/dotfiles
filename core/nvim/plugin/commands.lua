vim.api.nvim_create_user_command(
  "PackDel",
  function(cmd) vim.pack.del(cmd.fargs, { force = cmd.bang }) end,
  {
    nargs = "+",
    bang = true,
    desc = "Delete installed vim.pack plugins from disk (use ! to force-delete active plugins)",
    complete = function(arg_lead)
      local names = vim.tbl_map(function(plug) return plug.spec.name end, vim.pack.get())
      table.sort(names)
      return vim.tbl_filter(function(name) return vim.startswith(name, arg_lead) end, names)
    end,
  }
)
