return {
  "Bekaboo/dropbar.nvim",
  -- optional, but required for fuzzy finder support
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  opts = {
    general = {
      -- TODO: report this issue on dropbar.nvim
      ---@type boolean|fun(buf: integer, win: integer, info: table?): boolean
      enable = function(buf, win, _)
        local ft = vim.bo[buf].ft
        if ft == "typescriptreact" then
          ft = "typescript"
        end

        return vim.api.nvim_buf_is_valid(buf)
          and vim.api.nvim_win_is_valid(win)
          and vim.wo[win].winbar == ""
          and vim.fn.win_gettype(win) == ""
          and ((pcall(vim.treesitter.get_parser, buf, ft)) and true or false)
      end,
    },
  },
  lazy = false,
  keys = {
    {
      "gm",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Open dropbar picker",
    },
  },
}
