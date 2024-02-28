local function openNeogit()
  local neogit = require("neogit")

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    neogit.open({ kind = "replace" })
  else
    local w = vim.api.nvim_win_get_width(0)
    local h = vim.api.nvim_win_get_height(0)
    local kind = "split"

    if w > h * 3 then
      kind = "vsplit"
    end
    neogit.open({ kind = kind })
  end
end

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    -- "sindrets/diffview.nvim",        -- optional - Diff integration

    "nvim-telescope/telescope.nvim",
  },
  config = true,
  keys = {
    {
      "<leader>gg",
      openNeogit,
      desc = "Neogit",
    },
  },
}
