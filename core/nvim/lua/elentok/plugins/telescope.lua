local current_text = require("elentok.lib.current-text")

local function telescope_git_last_commit_files()
  require("telescope.builtin").find_files({
    find_command = {
      "git",
      "diff-tree",
      "--no-commit-id",
      "--name-only",
      "-r",
      "HEAD",
    },
  })
end

return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  lazy = true,
  dependencies = {
    -- { "natecraddock/telescope-zf-native.nvim" },
    "fdschmidt93/telescope-egrepify.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "aaronhallaert/advanced-git-search.nvim", cmd = "AdvancedGitSearch" },
    { "debugloop/telescope-undo.nvim" },
  },
  cmd = { "Telescope", "Maps", "Glast" },
  keys = {
    {
      "<leader>ff",
      "<cmd>Telescope egrepify<cr>",
      mode = "n",
      desc = "Live grep",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string()
      end,
      mode = { "n", "v" },
      { desc = "Grep word under cursor" },
    },
    { "<c-p>", "<cmd>Telescope find_files<cr>" },
    { "<leader>p", "<cmd>Telescope find_files<cr>" },
    { "<leader>.", "<cmd>Telescope find_files<cr>" },
    { "z=", "<cmd>Telescope spell_suggest<cr>" },
    { "<leader>jb", "<cmd>Telescope buffers file_ignore_patterns={}<cr>" },
    { "<leader>jg", "<cmd>Telescope git_status<cr>", desc = "Jump to git modified" },
    { "<leader>jj", "<cmd>Telescope jumplist<cr>", desc = "Jump to jumplist" },
    { "<leader>jh", "<cmd>Telescope help_tags<cr>", desc = "Jump to help" },
    { "<leader>jl", telescope_git_last_commit_files, desc = "Jump to files in last commit" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Goto reference (LSP)" },
    { "``", "<cmd>Telescope resume<cr>", desc = "Resume last telescope search" },
    { "<Leader>gt", "<cmd>Telescope tags<cr>" },
    {
      "<Leader>jm",
      "<cmd>Telescope oldfiles previewer=false only_cwd=true<cr>",
      desc = "Jump to MRU (locally)",
    },
    {
      "<Leader>jM",
      "<cmd>Telescope oldfiles previewer=false<cr>",
      desc = "Jump to MRU (globally)",
    },
    {
      "<Leader>js",
      function()
        require("telescope").extensions.aerial.aerial()
      end,
      desc = "Goto symbol",
    },
    {
      "<leader>ju",
      "<cmd>Telescope undo<cr>",
      mode = "n",
      desc = "Undo history",
    },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")
    local ui = require("elentok.lib.ui")
    local conf = require("telescope.config").values

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
        fzf = {
          -- fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          -- case_mode = "smart_case",
        },
        egrepify = {
          prefixes = {
            ["%"] = {
              flag = "iglob",
              cb = function(input)
                return string.format([[!*.{%s}]], input)
              end,
            },
            [">"] = {
              flag = "iglob",
              cb = function(input)
                return string.format([[**/{%s}*/**]], input)
              end,
            },
            ["<"] = {
              flag = "iglob",
              cb = function(input)
                return string.format([[!**/{%s}*/**]], input)
              end,
            },
            ["&"] = {
              flag = "iglob",
              cb = function(input)
                return string.format([[*{%s}*]], input)
              end,
            },
            ["!"] = {
              flag = "iglob",
              cb = function(input)
                return string.format([[!*{%s}*]], input)
              end,
            },
          },
        },
      },
    })

    telescope.load_extension("aerial")
    telescope.load_extension("fzf")
    telescope.load_extension("advanced_git_search")
    telescope.load_extension("egrepify")
    telescope.load_extension("undo")

    vim.api.nvim_create_user_command("Maps", builtin.keymaps, {})
    vim.api.nvim_create_user_command("Glast", telescope_git_last_commit_files, {})
  end,
}
