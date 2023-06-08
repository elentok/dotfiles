local util = require("elentok/util")
local ui = require("elentok/lib/ui")

local commands = {
  ["Stash staged changes"] = "Git stash push --staged",
  ["Push"] = "Git push",
  ["Pull"] = "Git pull",
  ["Push feature"] = "Git psf",
  ["Pull and rebase main"] = "Git prm",
}

vim.keymap.set("n", "q", ":q<cr>", { buffer = true })
vim.keymap.set("n", "@", function()
  vim.ui.select(vim.tbl_keys(commands), {
    prompt = "Select command:",
  }, function(choice)
    local cmd = commands[choice]
    if cmd ~= nil then
      util.ishell(cmd)
    end
  end)
end, { buffer = true })
