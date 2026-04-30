local loaded = false

vim.keymap.set("n", "<leader>ld", function()
  local lazydiff = require("lazydiff")
  if not loaded then
    lazydiff.setup()
    loaded = true
  end
  lazydiff.toggle()
end, { desc = "Lazydiff" })
