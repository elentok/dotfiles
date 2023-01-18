local has_refactoring, refactoring = pcall(require, "refactoring")
local has_telescope, telescope = pcall(require, "telescope")

if not has_refactoring or not has_telescope then
  return
end

refactoring.setup({})
telescope.load_extension("refactoring")

-- remap to open the Telescope refactoring menu in visual mode
vim.keymap.set("v", "<space>rr", function()
  telescope.extensions.refactoring.refactors()
end)

vim.keymap.set("n", "<space>rv", function()
  refactoring.debug.print_var({ normal = true })
end)

vim.keymap.set("n", "<space>rp", function()
  refactoring.debug.printf()
end)

vim.keymap.set("n", "<space>rc", refactoring.debug.cleanup)
