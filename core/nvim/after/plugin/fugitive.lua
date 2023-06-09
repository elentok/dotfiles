local group_id = vim.api.nvim_create_augroup("Elentok_Fugitive", {})
local util = require("elentok/util")

local commands = {
  ["Stash staged changes"] = "Git stash push --staged",
  ["Push"] = "Git push",
  ["Pull"] = "Git pull",
  ["Push feature"] = "Git psf",
  ["Pull and rebase main"] = "Git prm",
}

local function command_pallete()
  vim.ui.select(vim.tbl_keys(commands), {
    prompt = "Select command:",
  }, function(choice)
    local cmd = commands[choice]
    if cmd ~= nil then
      util.ishell(cmd)
    end
  end)
end

local function setup_fugitive()
  vim.keymap.set("n", "R", ":e<cr>:echo 'Reloaded'<cr>", { buffer = true })
  vim.keymap.set("n", "q", ":q<cr>", { buffer = true })
  vim.keymap.set("n", "@", command_pallete, { buffer = true })
end

vim.api.nvim_create_autocmd(
  { "Filetype" },
  { pattern = "fugitive", callback = setup_fugitive, group = group_id }
)
