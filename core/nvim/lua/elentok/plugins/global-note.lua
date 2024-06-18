return {
  "backdround/global-note.nvim",
  opts = {
    filename = "scratchpad.txt",
    directory = "~/notes/home",
  },
  keys = {
    {
      "<leader>n",
      function()
        require("global-note").toggle_note()
      end,
      desc = "Toggle note",
    },
  },
}
