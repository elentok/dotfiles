local function openNeogit()
  local neogit = require("neogit")

  local cwd = vim.uv.cwd()

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    neogit.open({ kind = "replace", cwd = cwd })
  else
    local w = vim.api.nvim_win_get_width(0)
    local h = vim.api.nvim_win_get_height(0)
    local kind = "split"

    if w > h * 3 then
      kind = "vsplit"
    end
    neogit.open({ kind = kind, cwd = cwd })
  end
end

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
  },
  opts = {
    console_timeout = 4000,
    disable_insert_on_commit = "true",
    integration = {
      fzf_lua = true,
      diffview = true,
    },
    popup = {
      kind = "floating",
    },
    mappings = {
      status = {
        ["o"] = "GoToFile",
      },
    },
  },
  cmd = { "Neogit" },
  keys = {
    {
      "<leader>gg",
      openNeogit,
      desc = "Neogit",
    },
  },
}
