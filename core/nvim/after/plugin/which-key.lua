local wk = require("which-key")

wk.register({
  j = {
    name = "jump",
  },
  f = {
    name = "find",
  },
  g = {
    name = "git",
  },
  o = {
    name = "open",
  },
  t = {
    name = "toggle/test",
  },
}, { prefix = "<space>" })
