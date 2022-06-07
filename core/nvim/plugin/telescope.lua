local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope/actions")

telescope.setup({
  defaults = {
    -- file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = { "node_modules/.*", "scuba_goldens/.*" },
    mappings = {
      i = { ["<C-q>"] = actions.send_to_qflist + actions.open_qflist },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

telescope.load_extension("aerial")
telescope.load_extension("fzf")
telescope.load_extension("file_browser")

vim.keymap.set("n", "<c-p>", builtin.find_files)
vim.keymap.set("n", "<Leader>b", builtin.buffers)
vim.keymap.set("n", "<Leader>gt", builtin.tags)
vim.keymap.set("n", "<Leader>gg", builtin.git_status)
vim.keymap.set("n", "<Leader>gh", builtin.help_tags)
vim.keymap.set("n", "<Leader>gm", function()
  builtin.oldfiles({ previewer = false })
end)
vim.keymap.set("n", "<Leader>fe", function()
  telescope.extensions.file_browser.file_browser({ path = "%:p:h" })
end)
vim.keymap.set("n", "gl", builtin.current_buffer_fuzzy_find)
vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "``", builtin.resume)
vim.keymap.set("n", "gs", telescope.extensions.aerial.aerial)
vim.keymap.set("n", "gb", function()
  require("elentok/telescope").buf_tags_picker()
end)
