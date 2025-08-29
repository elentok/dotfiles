return {
  {
    "nvim-mini/mini.icons",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  { "nvim-mini/mini.bracketed", event = { "LazyFile" }, version = "*", opts = {} },
  {
    "nvim-mini/mini.surround",
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
  { "nvim-mini/mini.pairs", event = { "InsertEnter" }, version = "*", opts = {} },
  {
    "nvim-mini/mini.move",
    event = { "LazyFile" },
    version = "*",
    opts = {},
  },
}
