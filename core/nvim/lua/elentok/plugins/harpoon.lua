return {
  "ThePrimeagen/harpoon",
  opts = {},
  keys = {
    {
      "<leader>ea",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "Harpoon add file",
    },
    {
      "<leader>ee",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "Harpoon menu",
    },
    {
      "<leader>1",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "Harpoon jump to #1",
    },
    {
      "<leader>2",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "Harpoon jump to #2",
    },
    {
      "<leader>3",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "Harpoon jump to #3",
    },
    {
      "<leader>4",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "Harpoon jump o #4",
    },
  },
}
