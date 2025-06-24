return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  { "echasnovski/mini.bracketed", event = { "LazyFile" }, version = "*", opts = {} },
  {
    "echasnovski/mini.surround",
    event = { "LazyFile" },
    version = "*",
    opts = {
      custom_surroundings = {
        s = {
          input = { "%*%*().-()%*%*" },
          output = { left = "**", right = "**" },
        },
        c = {
          input = { "```\n().-()\n```" },
          output = { left = "```\n", right = "```" },
        },
      },
    },
  },
  { "echasnovski/mini.pairs", event = { "InsertEnter" }, version = "*", opts = {} },
  {
    "echasnovski/mini.move",
    event = { "LazyFile" },
    version = "*",
    opts = {},
  },
}
