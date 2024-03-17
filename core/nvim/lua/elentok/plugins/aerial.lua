return {
  "stevearc/aerial.nvim",

  opts = {
    backends = {
      ["_"] = { "lsp", "treesitter" },
      markdown = { "markdown" },
    },
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
      "Constant",
      "Variable",
    },
    on_attach = function(bufnr)
      vim.keymap.set("n", "<leader>ta", "<cmd>AerialToggle left<cr>", { buffer = bufnr })
      vim.keymap.set("n", "[[", "<cmd>AerialPrev<cr>", { buffer = bufnr })
      vim.keymap.set("n", "]]", "<cmd>AerialNext<cr>", { buffer = bufnr })
      vim.keymap.set(
        "n",
        "<leader>oa",
        "<cmd>AerialNavOpen<cr>",
        { buffer = bufnr, desc = "Open Aerial navigation" }
      )
    end,
    nav = {
      keymaps = {
        ["?"] = "actions.help",
        ["q"] = "actions.close",
      },
    },
  },

  init = function()
    vim.cmd([[hi link AerialLine DiffAdd]])
  end,
}
