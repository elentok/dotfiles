-- vim.opt.foldlevel = 20
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldtext = "getline(v:foldstart)"
--
-- -- Deal with issue where folding disappears on save
-- local group_id = vim.api.nvim_create_augroup("Elentok_Folding", {})
--
-- vim.api.nvim_create_autocmd(
--   "BufWritePost",
--   { group = group_id, pattern = "*", command = "e | normal zv" }
-- )

--
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = "getline(v:foldstart)"

-- Setting the foldexpr like this causes vim to crash so I'm using the
-- nvim_treesitter variation (https://github.com/neovim/neovim/issues/25608)
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- local group_id = vim.api.nvim_create_augroup("Elentok_Folding", {})

-- local function setupFolding()
-- print("setup folding")
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldtext = "getline(v:foldstart)"
-- if vim.bo.filetype == "markdown" then
--   vim.opt.foldexpr = "v:lua.MarkdownFoldExpr(v:lnum)"
-- else
--   vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- end
-- vim.cmd("normal zx")
-- end

-- vim.api.nvim_create_autocmd("BufRead", { group = group_id, pattern = "*", callback = setupFolding })

function MarkdownFoldExpr(lnum)
  local line = vim.fn.getline(lnum)

  -- Check for a Markdown heading
  local _, _, level = string.find(line, "^(#+)")
  if level then
    return ">" .. string.len(level)
  end

  -- Return 0 if not a heading (i.e., do not fold)
  return "="
end
