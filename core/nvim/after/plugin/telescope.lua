local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")
local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
local builtin = require("telescope.builtin")
local actions = require("telescope/actions")

telescope.setup({
  defaults = {
    -- file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = { "node_modules/.*", "scuba_goldens/.*" },
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-r"] = actions.delete_buffer,
      },
      n = {
        ["q"] = actions.close,
        ["x"] = actions.delete_buffer,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          ["<C-t>"] = lga_actions.quote_prompt({ postfix = " --t " }),
        },
      },
    },
  },
})

telescope.load_extension("aerial")
telescope.load_extension("fzf")
telescope.load_extension("file_browser")

vim.keymap.set("n", "<c-p>", builtin.find_files)
vim.keymap.set("n", "z=", builtin.spell_suggest)
vim.keymap.set("n", "<Leader>b", function()
  builtin.buffers({ file_ignore_patterns = {} })
end)
-- vim.keymap.set("n", "<Leader>gt", builtin.tags)
vim.keymap.set("n", "<Leader>gg", builtin.git_status)
vim.keymap.set("n", "<Leader>gj", builtin.jumplist)
vim.keymap.set("n", "<Leader>gh", builtin.help_tags)
vim.keymap.set("n", "<Leader>gm", function()
  builtin.oldfiles({ previewer = false, only_cwd = true })
end)
vim.keymap.set("n", "<Leader>gM", function()
  builtin.oldfiles({ previewer = false })
end)
vim.keymap.set("n", "<Leader>fe", function()
  telescope.extensions.file_browser.file_browser({ path = "%:p:h" })
end)
vim.keymap.set("n", "<Leader>ff", function()
  telescope.extensions.live_grep_args.live_grep_args()
end)
vim.keymap.set(
  "n",
  "<Leader>fw",
  lga_shortcuts.grep_word_under_cursor,
  { desc = "Grep word under cursor" }
)
vim.keymap.set(
  "v",
  "<Leader>fw",
  lga_shortcuts.grep_visual_selection,
  { desc = "Grep visual selection" }
)
vim.keymap.set("n", "<Leader>fe", function()
  telescope.extensions.file_browser.file_browser({ path = "%:p:h" })
end)
-- vim.keymap.set("n", "gl", builtin.current_buffer_fuzzy_find)
vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "``", builtin.resume)
vim.keymap.set("n", "gs", telescope.extensions.aerial.aerial)
vim.keymap.set("n", "gb", function()
  require("elentok/lib/telescope").buf_tags_picker()
end)

vim.api.nvim_create_user_command("Maps", builtin.keymaps, {})
