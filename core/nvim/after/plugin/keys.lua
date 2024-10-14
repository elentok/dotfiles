-- vim: foldmethod=marker

local ui = require("elentok.lib.ui")
local term = require("elentok.lib.terminal")

---@param cmd string
local function confirm_force_if_modified(cmd)
  if vim.bo.modified then
    if ui.confirm("Buffer has unsaved changes, use '" .. cmd .. "!'?") then
      vim.cmd(cmd .. "!")
    else
      print("Aborting")
    end
  else
    vim.cmd(cmd)
  end
end

vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "jl", "<esc>")
vim.keymap.set("n", "<leader>k", ":")
vim.keymap.set("n", "<leader>;", ":")

vim.keymap.set("n", "<leader>wq", "<cmd>wq<cr>", { desc = ":wq" })
vim.keymap.set("n", "<leader>ww", "<cmd>w<cr>", { desc = ":w" })
vim.keymap.set("n", "<leader>wa", "<cmd>wa<cr>", { desc = ":wa" })
vim.keymap.set("n", "<leader>qq", "<cmd>q<cr>", { desc = ":q" })
vim.keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = ":qa" })
vim.keymap.set("n", "<leader>cq", "<cmd>cq<cr>", { desc = ":cq" })

vim.keymap.set("n", "<leader>wh", "<c-w>h", { desc = "Window left" })
vim.keymap.set("n", "<leader>wj", "<c-w>j", { desc = "Window down" })
vim.keymap.set("n", "<leader>wk", "<c-w>k", { desc = "Window up" })
vim.keymap.set("n", "<leader>wl", "<c-w>l", { desc = "Window right" })

vim.keymap.set("n", "<leader>wH", "<c-w>H", { desc = "Move Window left" })
vim.keymap.set("n", "<leader>wJ", "<c-w>J", { desc = "Move Window down" })
vim.keymap.set("n", "<leader>wK", "<c-w>K", { desc = "Move Window up" })
vim.keymap.set("n", "<leader>wL", "<c-w>L", { desc = "Move Window right" })

vim.keymap.set("n", "<leader>we", "<c-w>=", { desc = "Window equal size" })
vim.keymap.set("n", "<leader>w/", "5<c-w>>", { desc = "Window equal size" })
vim.keymap.set("n", "<leader>w,", "5<c-w><", { desc = "Window equal size" })
vim.keymap.set("n", "<leader>wi", "5<c-w>+", { desc = "Window equal size" })
vim.keymap.set("n", "<leader>wu", "5<c-w>-", { desc = "Window equal size" })

vim.keymap.set("n", "<leader>bd", function()
  confirm_force_if_modified("bd")
end, { desc = ":bd" })

vim.keymap.set("n", ",,", "<cmd>nohls<cr>")
vim.keymap.set({ "n", "v" }, ",a", "A")
vim.keymap.set({ "n", "v" }, ",c", "V")

-- Enter as a secondary leader
-- vim.keymap.set("n", "<cr><cr>", "<cmd>nohls<cr>")
-- vim.keymap.set("n", "<cr>x", "<cmd>bd<cr>")
-- vim.keymap.set("n", "<cr>w", "<cmd>w<cr>")
-- vim.keymap.set({ "n", "v" }, "<cr>a", "A")
-- vim.keymap.set({ "n", "v" }, "<cr>c", "V")

-- Switch to alternate file
vim.keymap.set("n", "<leader><leader>", "<c-^>")

vim.keymap.set("n", "<c-s>", "<cmd>w<cr>")
vim.keymap.set("i", "<c-s>", "<c-o>:w<cr>")

-- Avoid paste override {{{1
-- From https://github.com/skwp/dotfiles/blob/master/vim/plugin/settings/stop-visual-paste-insanity.vim:
-- If you visually select something and hit paste that thing gets yanked into
-- your buffer. This generally is annoying when you're copying one item and
-- repeatedly pasting it. This changes the paste command in visual mode so that
-- it doesn't overwrite whatever is in your paste buffer.
vim.keymap.set("v", "p", '"_dP')

-- Yank Markdown to HTML {{{1
vim.keymap.set(
  "v",
  "<Leader>md",
  "<cmd>!pandoc --from markdown --to html | copy-html<cr>u",
  { desc = "Copy with markdown-to-HTML" }
)
vim.keymap.set(
  "n",
  "<Leader>md",
  "<cmd>%!pandoc --from markdown --to html | copy-html<cr>u",
  { desc = "Copy with markdown-to-HTML" }
)

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
-- vim.keymap.set("n", "_", "<cmd>Vifm<cr>")

-- vim.keymap.set("n", "<cr>", "<cmd>nohls<cr><cr>")
-- vim.keymap.set("n", "<Leader><Leader>", "<cmd>silent !tput clear<cr>:redraw!<cr>")

vim.keymap.set("v", "<tab>", ">gv")
vim.keymap.set("v", "<s-tab>", "<gv")

vim.keymap.set("v", "<leader>ss", ":sort<cr>", { desc = "Sort" })
vim.keymap.set("v", "<leader>st", ":!todo-sort<cr>", { desc = "Sort (todo)" })
vim.keymap.set("n", "<leader>st", ":%!todo-sort<cr>", { desc = "Sort (todo)" })
vim.keymap.set("n", "<leader>ya", ":%y+<cr>", { desc = "Yank entires file" })
vim.keymap.set("n", "<leader>yf", ':let @+ = expand("%:.")<cr>', { desc = "Yank current filename" })

-- vim.keymap.set("n", "<leader>cl", function()
--   term.run("FORCE_COLOR=1 mycal.ts | less", { w = 0.5 })
-- end, { desc = "Calendar" })

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

vim.keymap.set("v", "<leader>rp", "<cmd>!prettierd %<cr>", { desc = "Run prettier" })
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

vim.keymap.set("n", "<leader>of", "<cmd>!dotf-open %<cr>", { desc = "Open current file" })

vim.keymap.set("n", "<leader>ov", function()
  term.run({ "vifm", "--select", vim.fn.expand("%") })
end, { desc = "Open Vifm" })

vim.keymap.set("n", "<leader>ol", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

vim.keymap.set("n", "<leader>dd", '"3dd', { desc = "Delete line without overwriting register" })
vim.keymap.set(
  "v",
  "<leader>x",
  '"3x',
  { desc = "Delete visual selecting without overwriting register" }
)

vim.keymap.set("n", "<leader>rel", ":g/^$/d<cr>", { desc = "Remove empty lines" })
vim.keymap.set("n", "rel", "<c-v>", { desc = "Go into visual block mode" })

vim.keymap.set("n", "<leader>wh", "<c-w>h", { desc = "Go to window to the left" })
vim.keymap.set("n", "<leader>wj", "<c-w>j", { desc = "Go to window below" })
vim.keymap.set("n", "<leader>wk", "<c-w>k", { desc = "Go to window above" })
vim.keymap.set("n", "<leader>wl", "<c-w>l", { desc = "Go to window to the right" })
vim.keymap.set("n", "<leader>wo", "<c-w>o", { desc = "Only window" })
vim.keymap.set("n", "<leader>ws", "<c-w>s", { desc = "Split window" })
vim.keymap.set("n", "<leader>wv", "<c-w>v", { desc = "Split window vertically" })
vim.keymap.set({ "n", "v" }, "<leader>vv", "<c-v>", { desc = "Go into block visual mode" })
vim.keymap.set("n", "vv", "V", { desc = "Go into visual line mode" })
vim.keymap.set("n", "vb", "<c-v>", { desc = "Go into visual block mode" })

-- Evaluate the current math expression
vim.keymap.set("v", "<leader>xx", '"mygvA = <c-r>=<c-r>m<cr>', { desc = "Evaluate" })

-- Inspired by Helix
vim.keymap.set({ "n", "v" }, "gh", "0", { desc = "Go to beginning of the line" })
vim.keymap.set({ "n", "v" }, "ge", "G", { desc = "Go to end of the file" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to end of the line" })
vim.keymap.set({ "n", "v" }, "gs", "_", { desc = "Go to first non-blank character" })

-- Map <leader>n and <leader>p to [ and ] to make it easier to use unimpaired
-- mappings without [ and ]
vim.keymap.set({ "n", "v" }, "<leader>p", "[", { remap = true })
vim.keymap.set({ "n", "v" }, "<leader>n", "]", { remap = true })

-- Similar, but with , and .
vim.keymap.set({ "n", "v" }, "<leader>,", "[", { remap = true })
vim.keymap.set({ "n", "v" }, "<leader>.", "]", { remap = true })
