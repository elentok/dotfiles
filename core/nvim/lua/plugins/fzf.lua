return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-mini/mini.icons" },
  ---@module 'fzf-lua'
  ---@type fzf-lua.Config
  opts = {
    ---@diagnostic disable-next-line: missing-fields
    grep = {
      multiline = 1,
    },
  },
  cmd = "FzfLua",
  keys = {
    { "<leader><space>", ":FzfLua files<cr>", desc = "FzfLua file picker" },
    { "<leader>ff", ":FzfLua files<cr>", desc = "FzfLua file picker" },
    { "``", ":FzfLua resume<cr>", desc = "Resume last picker" },
    { "<leader>jr", ":FzfLua oldfiles cwd=$PWD<cr>", desc = "Find recent files" },
    { "<leader>jR", ":FzfLua oldfiles<cr>", desc = "Find recent files (global)" },

    { "<leader>jb", ":FzfLua buffers<cr>", desc = "Buffers" },
    { "<leader>,", ":FzfLua buffers<cr>", desc = "Buffers" },
    { "<leader>:", ":FzfLua command_history<cr>", desc = "Command History" },

    { "grr", ":FzfLua lsp_references<cr>", desc = "LSP references" },

    { "<leader>/", ":FzfLua live_grep<cr>", desc = "Live grep" },
    { "<leader>w/", ":FzfLua grep_cword<cr>", desc = "Grep word" },
    { "<leader>/", ":FzfLua grep_visual<cr>", mode = "v", desc = "Grep selection" },

    { "<leader>js", ":FzfLua lsp_document_symbols<cr>", desc = "Jump to LSP symbol" },
    { "<leader>jh", ":FzfLua helptags<cr>", desc = "Help Pages" },
    { "<leader>jk", ":FzfLua keymaps<cr>", desc = "Keymaps" },

    { "gre", ":FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
    { "grd", ":FzfLua diagnostics_document<cr>", desc = "Buffer Diags" },

    { "<leader>gl", ":FzfLua git_bcommits<cr>", desc = "Show git log" },
    { "<leader>gL", ":FzfLua git_blame<cr>", desc = "Show git history of current line" },
    { "<leader>gD", ":FzfLua git_diff<cr>", desc = "Git Diff (hunks)" },
    { "<leader>gs", ":FzfLua git_status<cr>", desc = "Git Status" },
  },
}
