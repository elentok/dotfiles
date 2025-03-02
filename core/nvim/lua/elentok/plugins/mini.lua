return {
  -- { "echasnovski/mini.nvim", version = "*" },
  { "echasnovski/mini.icons", version = "*", opts = {} },
  { "echasnovski/mini.bracketed", version = "*", opts = {} },
  { "echasnovski/mini.surround", version = "*", opts = {} },
  -- { "echasnovski/mini.jump", version = "*", opts = {} },
  { "echasnovski/mini.comment", version = "*", opts = {} },
  { "echasnovski/mini.pairs", version = "*", opts = {} },
  {
    "echasnovski/mini.ai",
    version = "*",
    config = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      require("mini.ai").setup({
        custom_textobjects = {
          -- Function definition (needs treesitter queries with these captures)
          f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          o = spec_treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),
        },
      })
    end,
  },
  {
    "echasnovski/mini.move",
    version = "*",
    opts = {},
  },
}
