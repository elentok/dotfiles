local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")
local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
local builtin = require("telescope.builtin")
local actions = require("telescope/actions")
local ui = require("elentok.lib.ui")

telescope.setup({
  defaults = {
    -- file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = { "node_modules/.*", "scuba_goldens/.*" },
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-f>"] = actions.to_fuzzy_refine,
        ["<C-r>"] = actions.delete_buffer,
        ["<C-d>"] = actions.cycle_history_next,
        ["<C-u>"] = actions.cycle_history_prev,
      },
      n = {
        ["q"] = actions.close,
        ["f"] = actions.to_fuzzy_refine,
        ["x"] = actions.delete_buffer,
      },
    },
  },
  extensions = {
    -- fzf = {
    --   fuzzy = true,
    --   override_generic_sorter = true,
    --   override_file_sorter = true,
    --   case_mode = "smart_case",
    -- },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = function()
            ui.feedkeys(" --iglob **/**<left>", "n")
          end,
          ["<C-e>"] = function()
            ui.feedkeys(" --iglob !**/**<left>", "n")
          end,
          ["<C-t>"] = function()
            ui.feedkeys(" -t", "n")
          end,
        },
      },
    },
  },
})

local ok_aerial, _ = pcall(require, "aerial")
if ok_aerial then
  telescope.load_extension("aerial")
  vim.keymap.set("n", "<leader>js", telescope.extensions.aerial.aerial, { desc = "Goto symbol" })
end
-- telescope.load_extension("fzf")
telescope.load_extension("zf-native")
telescope.load_extension("file_browser")
telescope.load_extension("advanced_git_search")
telescope.load_extension("live_grep_args")

vim.keymap.set("n", "<c-p>", builtin.find_files)
vim.keymap.set("n", "<leader>p", builtin.find_files)
vim.keymap.set("n", "<leader>.", builtin.find_files)
vim.keymap.set("n", "z=", builtin.spell_suggest)
vim.keymap.set("n", "<leader>jb", function()
  builtin.buffers({ file_ignore_patterns = {} })
end)
-- vim.keymap.set("n", "<Leader>gt", builtin.tags)
vim.keymap.set("n", "<leader>jg", builtin.git_status, { desc = "Jump to git modified" })
vim.keymap.set("n", "<leader>jj", builtin.jumplist, { desc = "Jump to jumplist" })
vim.keymap.set("n", "<leader>jh", builtin.help_tags, { desc = "Jump to help" })
vim.keymap.set("n", "<leader>jm", function()
  builtin.oldfiles({ previewer = false, only_cwd = true })
end, { desc = "Jump to MRU (locally)" })
vim.keymap.set("n", "<leader>jM", function()
  builtin.oldfiles({ previewer = false })
end, { desc = "Jump to MRU (globally)" })

vim.keymap.set("n", "<Leader>fe", function()
  telescope.extensions.file_browser.file_browser({ path = "%:p:h" })
end)

vim.keymap.set("n", "<leader>ff", function()
  telescope.extensions.live_grep_args.live_grep_args()
end, { desc = "Live grep (args)" })

vim.keymap.set(
  "n",
  "<leader>fw",
  lga_shortcuts.grep_word_under_cursor,
  { desc = "Grep word under cursor" }
)

vim.keymap.set(
  "v",
  "<leader>fw",
  lga_shortcuts.grep_visual_selection,
  { desc = "Grep visual selection" }
)

vim.keymap.set("n", "<Leader>fe", function()
  telescope.extensions.file_browser.file_browser({ path = "%:p:h" })
end)
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Goto reference (LSP)" })
vim.keymap.set("n", "``", builtin.resume, { desc = "Resume last telescope search" })

vim.api.nvim_create_user_command("Maps", builtin.keymaps, {})
