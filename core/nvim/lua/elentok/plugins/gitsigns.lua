return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  lazy = false,
  init = function()
    vim.opt.signcolumn = "yes"
  end,
  keys = {
    {
      "<leader>b",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Git blame (current line)",
    },

    { "<leader>gm", ":Gitsigns<cr>", desc = "Git signs menu" },
    {
      "<leader>gbb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Git blame line",
    },
    { "<leader>gpp", ":Gitsigns preview_hunk<cr>", desc = "Git preview hunk" },
    { "<leader>gi", ":Gitsigns preview_hunk_inline<cr>", desc = "Git preview hunk (inline)" },
    { "[c", ":Gitsigns prev_hunk<cr>", desc = "Prev git hunk" },
    { "]c", ":Gitsigns next_hunk<cr>", desc = "Next git hunk" },

    -- Text object
    { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" } },
  },
}
