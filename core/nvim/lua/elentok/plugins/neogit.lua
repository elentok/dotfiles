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
  config = function()
    require("neogit").setup({
      disable_insert_on_commit = true,
      integration = {
        telescope = true,
        diffview = true,
      },
      popup = {
        kind = "floating",
      },
    })

    -- jump to the top of the buffer when opening a commit message
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = { "NeogitCommitMessage" },
      callback = function()
        vim.defer_fn(function()
          vim.cmd("normal gg")
        end, 50)
      end,
    })
  end,
  cmd = { "Neogit" },
  keys = {
    {
      "<leader>gg",
      openNeogit,
      desc = "Neogit",
    },
  },
}
