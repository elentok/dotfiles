local lspconfig = require("lspconfig")
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()

-- Helper for tab completion
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Mappings
local cmp_mapping = {
  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<C-e>"] = cmp.mapping.abort(),
  ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  -- From https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
      -- they way you will only jump inside the snippet region
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
}

-- Setup CMP
cmp.setup({
  performance = {
    debounce = 150,
    async_budget = 30,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip", keyword_length = 2 },
    { name = "buffer", keyword_length = 3 },
    { name = "path" },
    { name = "rg", keyword_length = 4 },
  },
  mapping = cmp_mapping,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
      before = function(entry, vim_item)
        vim_item.menu = entry.source.name
        return vim_item
      end,
    }),
  },
})

-- Setup completion capabilities
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
require("mason-lspconfig").setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = lsp_capabilities,
    })
  end,
})

-- cmp.setup({
--   },
--   sources = cmp.config.sources({
--     { name = "dictionary", keyword_length = 5 },
--   }),
--
-- require("cmp_dictionary").setup({
--   dic = { ["*"] = { "/usr/share/dict/american-english" } },
-- })
--
-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- -- cmp.setup.cmdline("/", {
-- --   mapping = cmp.mapping.preset.cmdline(),
-- --   sources = { { name = "buffer" } },
-- -- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- -- cmp.setup.cmdline(":", {
-- --   mapping = cmp.mapping.preset.cmdline(),
-- --   sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
-- -- })
