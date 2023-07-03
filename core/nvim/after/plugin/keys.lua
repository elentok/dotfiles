-- vim: foldmethod=marker
vim.keymap.set("i", "jk", "<esc>")

-- Switch to alternate file
vim.keymap.set("n", "<space><space>", "<c-^>")

vim.keymap.set("n", "<c-s>", ":w<cr>")
vim.keymap.set("i", "<c-s>", "<c-o>:w<cr>")

-- Remove whitespace.
vim.keymap.set("n", "<Leader>rws", ":%s/\\s\\+$//<cr>")

-- Go to {{{1
vim.keymap.set("n", "<Leader>gd", ':cd <C-R>=expand("%:p:h")<cr>')

-- Avoid paste override {{{1
-- From https://github.com/skwp/dotfiles/blob/master/vim/plugin/settings/stop-visual-paste-insanity.vim:
-- If you visually select something and hit paste that thing gets yanked into
-- your buffer. This generally is annoying when you're copying one item and
-- repeatedly pasting it. This changes the paste command in visual mode so that
-- it doesn't overwrite whatever is in your paste buffer.
vim.keymap.set("v", "p", '"_dP')

-- Yank Markdown to HTML {{{1
vim.keymap.set("v", "<Leader>m", ":!pandoc --from markdown --to html | copy-html<cr>u")
vim.keymap.set("n", "<Leader>m", ":%!pandoc --from markdown --to html | copy-html<cr>u")

-- Version control {{{1
vim.keymap.set("n", "<Leader>tg", ":FloatermNew --width=0.8 --height=0.8 --autoclose=1 tig<cr>")
vim.keymap.set(
  "n",
  "<Leader>ts",
  ":FloatermNew --width=0.8 --height=0.8 --autoclose=1 tig status<cr>"
)
vim.keymap.set("n", "<Leader>vrp", ":Git co -p %<cr>")
vim.keymap.set(
  "n",
  "<Leader>vdf",
  ":FloatermNew --width=0.8 --height=0.8 --autoclose=0 git diff %<cr>"
)
-- " :Git diff %<cr>")
vim.keymap.set("n", "<Leader>vdc", " :Git diff --cached<cr>")
vim.keymap.set("n", "<Leader>vaf", ":Git add %<cr>")
vim.keymap.set(
  "n",
  "<Leader>vh",
  ":FloatermNew --width=0.8 --height=0.8 --autoclose=1 tig --follow %<cr>"
)
vim.keymap.set("n", "<Leader>vc", ":Gcommit<cr>")

-- Spaces text object {{{1
vim.keymap.set("x", "<space>", "f oT o", { silent = true })
vim.keymap.set("x", "a<space>", "f oF o", { silent = true })
vim.keymap.set("x", "i<space>", "t oT o", { silent = true })

-- Misc {{{1
vim.keymap.set("n", "<Leader>tm", ":set modifiable!<cr>:set modifiable?<cr>")
vim.keymap.set("n", "<Leader>tt", ":Twilight<cr>")
vim.keymap.set("n", "_", ":Vifm<cr>")

vim.keymap.set("n", "<cr>", ":nohls<cr><cr>")
vim.keymap.set("n", "<Leader><Leader>", ":silent !tput clear<cr>:redraw!<cr>")

vim.keymap.set("v", "<tab>", ">gv")
vim.keymap.set("v", "<s-tab>", "<gv")

vim.keymap.set("v", "<Leader>ss", ":sort<cr>")
vim.keymap.set("v", "<Leader>st", ":!todo-sort<cr>")
vim.keymap.set("n", "<Leader>st", ":%!todo-sort<cr>")
vim.keymap.set("n", "<Leader>ya", ":%y+<cr>")
vim.keymap.set("n", "<Leader>yf", ':let @+ = expand("%")<cr>', { desc = "Yank current filename" })

vim.keymap.set("n", "<Leader>oc", ":Calendar -view=year -split=vertical -width=27<cr>")

vim.keymap.set("n", "<backspace>", "zc")

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

vim.keymap.set("v", "<space>p", ":!prettierd %<cr>")
vim.keymap.set("n", "<leader>lg", ":LazyGit<cr>")
