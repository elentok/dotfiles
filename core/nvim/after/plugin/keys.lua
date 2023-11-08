local term = require("elentok/lib/terminal")
-- vim: foldmethod=marker
vim.keymap.set("i", "jk", "<esc>")

vim.keymap.set("n", "<space>wq", "<cmd>wq<cr>", { desc = ":wq" })
vim.keymap.set("n", "<space>ww", "<cmd>w<cr>", { desc = ":w" })
vim.keymap.set("n", "<space>qq", "<cmd>q<cr>", { desc = ":q" })
vim.keymap.set("n", "<space>qa", "<cmd>qa<cr>", { desc = ":qa" })

-- Switch to alternate file
vim.keymap.set("n", "<space><space>", "<c-^>")

vim.keymap.set("n", "<c-s>", "<cmd>w<cr>")
vim.keymap.set("i", "<c-s>", "<c-o>:w<cr>")

-- Remove whitespace.
vim.keymap.set("n", "<Leader>rws", "<cmd>%s/\\s\\+$//<cr>")

-- Avoid paste override {{{1
-- From https://github.com/skwp/dotfiles/blob/master/vim/plugin/settings/stop-visual-paste-insanity.vim:
-- If you visually select something and hit paste that thing gets yanked into
-- your buffer. This generally is annoying when you're copying one item and
-- repeatedly pasting it. This changes the paste command in visual mode so that
-- it doesn't overwrite whatever is in your paste buffer.
vim.keymap.set("v", "p", '"_dP')

-- Yank Markdown to HTML {{{1
vim.keymap.set("v", "<Leader>m", "<cmd>!pandoc --from markdown --to html | copy-html<cr>u")
vim.keymap.set("n", "<Leader>m", "<cmd>%!pandoc --from markdown --to html | copy-html<cr>u")

-- Version control {{{1
-- vim.keymap.set("n", "<Leader>tg", "<cmd>FloatermNew --width=0.8 --height=0.8 --autoclose=1 tig<cr>")
-- vim.keymap.set(
--   "n",
--   "<Leader>ts",
--   "<cmd>FloatermNew --width=0.8 --height=0.8 --autoclose=1 tig status<cr>"
-- )
-- vim.keymap.set("n", "<Leader>vrp", "<cmd>Git co -p %<cr>")
-- vim.keymap.set(
--   "n",
--   "<Leader>vdf",
--   "<cmd>FloatermNew --width=0.8 --height=0.8 --autoclose=0 git diff %<cr>"
-- )
-- " :Git diff %<cr>")
-- vim.keymap.set("n", "<Leader>vdc", " :Git diff --cached<cr>")
-- vim.keymap.set("n", "<Leader>vaf", "<cmd>Git add %<cr>")

-- Spaces text object {{{1
vim.keymap.set("x", "<space>", "f oT o", { silent = true })
vim.keymap.set("x", "a<space>", "f oF o", { silent = true })
vim.keymap.set("x", "i<space>", "t oT o", { silent = true })

-- Misc {{{1
vim.keymap.set("n", "<Leader>tm", "<cmd>set modifiable!<cr>:set modifiable?<cr>")
vim.keymap.set("n", "<Leader>tt", "<cmd>Twilight<cr>")
vim.keymap.set("n", "_", "<cmd>Vifm<cr>")

vim.keymap.set("n", "<cr>", "<cmd>nohls<cr><cr>")
vim.keymap.set("n", "<Leader><Leader>", "<cmd>silent !tput clear<cr>:redraw!<cr>")

vim.keymap.set("v", "<tab>", ">gv")
vim.keymap.set("v", "<s-tab>", "<gv")

vim.keymap.set("v", "<space>ss", ":sort<cr>", { desc = "Sort" })
vim.keymap.set("v", "<space>st", ":!todo-sort<cr>", { desc = "Sort (todo)" })
vim.keymap.set("n", "<space>st", ":%!todo-sort<cr>", { desc = "Sort (todo)" })
vim.keymap.set("n", "<space>ya", ":%y+<cr>", { desc = "Yank entires file" })
vim.keymap.set("n", "<space>yf", ':let @+ = expand("%")<cr>', { desc = "Yank current filename" })

vim.keymap.set("n", "<space>cl", function()
  term.run("FORCE_COLOR=1 mycal | less", { w = 0.5 })
end, { desc = "Calendar" })

-- vim.keymap.set("n", "<backspace>", "zc")

-- -- Use 'zz' to place cursor at top third of window
local function move_to_top_third()
  local window_lines = vim.fn.winheight(0)
  local one_sixth = math.floor(window_lines / 6)
  vim.cmd(":normal! zz")

  -- move the cursor down one-sixth of the screen
  vim.cmd(":normal! " .. one_sixth .. "j")

  -- recenter
  vim.cmd(":normal! zz")

  -- move cursor up one-sixth of the screen
  vim.cmd(":normal! " .. one_sixth .. "k")
end

vim.keymap.set("n", "zz", move_to_top_third)

vim.keymap.set("v", "<space>p", "<cmd>!prettierd %<cr>")
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>")

vim.keymap.set(
  "n",
  "j",
  "v:count ? (v:count > 1 ? \"m'\" . v:count : '') . 'j' : 'gj'",
  { expr = true }
)

vim.keymap.set(
  "n",
  "k",
  "v:count ? (v:count > 1 ? \"m'\" . v:count : '') . 'k' : 'gk'",
  { expr = true }
)

vim.keymap.set("n", "<space>ov", function()
  term.run({ "vifm", "--select", vim.fn.expand("%") })
end, { desc = "Open Vifm" })

vim.keymap.set("n", "<space>ol", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

vim.keymap.set("n", "<space>dd", '"3dd', { desc = "Delete line without overwriting register" })
vim.keymap.set(
  "v",
  "<space>x",
  '"3x',
  { desc = "Delete visual selecting without overwriting register" }
)
