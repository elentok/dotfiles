local filetypes = {
  "bash",
  "css",
  "diff",
  "dockerfile",
  "fish",
  "gitconfig",
  "gitcommit",
  "go",
  "gomod",
  "graphql",
  "groovy",
  "html",
  "javascript",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "python",
  "toml",
  "typescript",
  "typescriptreact",
  "xml",
  "yaml",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  callback = function() vim.treesitter.start() end,
})

-- Run TSUpdate when the treesitter package updates
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

-- require("nvim-treesitter-textobjects").setup({})

vim.keymap.set(
  { "x", "o" },
  "af",
  function()
    require("nvim-treesitter-textobjects.select").select_textobject(
      "@function.outer",
      "textobjects"
    )
  end
)
vim.keymap.set(
  { "x", "o" },
  "if",
  function()
    require("nvim-treesitter-textobjects.select").select_textobject(
      "@function.inner",
      "textobjects"
    )
  end
)

vim.keymap.set(
  { "n", "x", "o" },
  "]]",
  function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
  end
)

vim.keymap.set(
  { "n", "x", "o" },
  "[[",
  function()
    require("nvim-treesitter-textobjects.move").goto_previous_start(
      "@function.outer",
      "textobjects"
    )
  end
)
