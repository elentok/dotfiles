local function setup()
  vim.fn.matchadd("TodoInprogress", "\\[inprogress\\].*$")
  vim.fn.matchadd("TodoWaiting", "\\[waiting\\].*$")
  vim.fn.matchadd("TodoDone", "\\[x\\].*$")
  vim.fn.matchadd("TodoContext", "@[^ ]*")

  vim.api.nvim_set_hl(0, "TodoInprogress", { bg = "#EBCB8B", fg = "#000000" })
  vim.api.nvim_set_hl(0, "TodoWaiting", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "TodoDone", { fg = "#6C7A96" })
  vim.api.nvim_set_hl(0, "TodoContext", { fg = "#88c0d0", italic = true })

  vim.wo.foldmethod = "indent"
end

local group_id = vim.api.nvim_create_augroup("Elentok_Markdown", {})

vim.api.nvim_create_autocmd(
  { "BufRead", "WinNew" },
  { pattern = "*.md", group = group_id, callback = setup }
)

local has_builtin, builtin = pcall(require, "telescope.builtin")
if has_builtin then
  vim.keymap.set("n", "<Leader>gt", function()
    builtin.grep_string({ search = "[ ]", search_dirs = { vim.fn.expand("%") } })
  end)
end
