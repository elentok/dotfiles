return {
  "ThePrimeagen/harpoon",
  opts = {},
  keys = {
    {
      "<space>a",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "Harpoon add file",
    },
    {
      "<space>e",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "Harpoon menu",
    },
    {
      "<space>1",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "Harpoon jump to #1",
    },
    {
      "<space>2",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "Harpoon jump to #2",
    },
    {
      "<space>3",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "Harpoon jump to #3",
    },
    {
      "<space>4",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "Harpoon jump o #4",
    },
  },
}
