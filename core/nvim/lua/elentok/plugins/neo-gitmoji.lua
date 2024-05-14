local function insertGitmoji()
  local picker = require("neo-gitmoji.gitmoji-picker").open_gitmoji_picker
  picker(function(value)
    vim.api.nvim_put({ value.emoji }, "c", true, true)
  end)
end

return {
  "HenriqueArtur/neo-gitmoji.nvim",
  lazy = true,
  cmd = { "Gitmoji" },
  keys = {
    {
      "<leader>ig",
      insertGitmoji,
      desc = "Insert Gitmoji",
    },
  },
}
