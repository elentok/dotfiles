local util = require("elentok/util")
local cmp = util.safe_require("cmp")
local lspkind = util.safe_require("lspkind")
local luasnip = util.safe_require("luasnip")

if cmp == nil or lspkind == nil or luasnip == nil then
  put("WARNING: [completion.lua] One of cmp, lspkind or luasnip is missing.")
  return
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- From https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local function handle_tab(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

local function handle_shift_tab(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer", keyword_length = 3 },
    { name = "rg", keyword_length = 4 },
    { name = "path" },
    { name = "dictionary", keyword_length = 5 },
    { name = "luasnip" },
  }),
  mapping = {
    ["<Tab>"] = cmp.mapping(handle_tab, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(handle_shift_tab, { "i", "s" }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        cmdline = "[Cmd]",
        rg = "[rg]",
        dictionary = "[dict]",
      },
    }),
  },
})

require("cmp_dictionary").setup({
  dic = { ["*"] = { "/usr/share/dict/american-english" } },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline("/", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = { { name = "buffer" } },
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
-- })
