local FTerm = require("FTerm")

local function vifm()
  local t = FTerm:new({
    cmd = { "vifm", "--select", vim.fn.expand("%") },
  })

  t:open()
end

vim.api.nvim_create_user_command("Vifm", vifm, {})
vim.keymap.set("n", "<Leader>gv", vifm)
