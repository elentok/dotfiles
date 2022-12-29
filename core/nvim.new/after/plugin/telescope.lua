local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})

local function goto_config()
  builtin.find_files({
    find_command = { "rg", "-t", "lua", "-t", "vim", "--files" },
    cwd = vim.env.HOME,
    search_dirs = {vim.env.DOTF .. '/core/nvim.new'},
  })
end

vim.keymap.set('n', '<Leader>gc', goto_config, {})
vim.keymap.set('n', '<Leader>gh', builtin.help_tags, {})
