local group_id = vim.api.nvim_create_augroup("Elentok_Fugitive", {})

local commands = {
  ["Stash staged changes"] = { "stash", "push", "--staged" },
  ["Push"] = { "push" },
  ["Pull"] = { "pull" },
  ["Push feature"] = { "psf" },
  ["Pull and rebase main"] = { "prm" },
}

local function command_pallete()
  local git = require("elentok.lib.git")
  vim.ui.select(vim.tbl_keys(commands), {
    prompt = "Select command:",
  }, function(choice)
    local cmd = commands[choice]
    if cmd ~= nil then
      git.run(cmd)
    end
  end)
end

local function setup_fugitive()
  vim.keymap.set("n", "R", "<cmd>e<cr><cmd>echo 'Reloaded'<cr>", { buffer = true })
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true })
  vim.keymap.set("n", "@", command_pallete, { buffer = true })
  vim.keymap.set("n", "zo", "=", { buffer = true, remap = true })
  vim.keymap.set("n", "zc", "=", { buffer = true, remap = true })
end

local function setup_fugitive_blame()
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true })
end

return {
  "tpope/vim-fugitive",
  lazy = true,
  cmd = { "G", "Gwrite", "Gread" },
  config = function()
    vim.api.nvim_create_autocmd(
      { "Filetype" },
      { pattern = "fugitive", callback = setup_fugitive, group = group_id }
    )

    vim.api.nvim_create_autocmd(
      { "Filetype" },
      { pattern = "fugitiveblame", callback = setup_fugitive_blame, group = group_id }
    )
  end,
}
