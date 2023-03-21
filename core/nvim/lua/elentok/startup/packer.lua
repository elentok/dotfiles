return require("packer").startup({
  function()
    use("wbthomason/packer.nvim")

    -- use("williamboman/mason.nvim")
    -- use("williamboman/mason-lspconfig.nvim")
    -- use("neovim/nvim-lspconfig")
    -- Extra LSP plugins
    -- use({
    --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --   config = function()
    --     require("lsp_lines").setup()
    --
    --     -- Disable virtual_text since it's redundant due to lsp_lines.
    --     vim.diagnostic.config({
    --       virtual_text = false,
    --     })
    --   end,
    -- })

    -- Completion.
    -- use("hrsh7th/cmp-nvim-lsp")
    -- use("hrsh7th/cmp-buffer")
    -- use("hrsh7th/cmp-path")
    -- use("hrsh7th/nvim-cmp")

    -- Do I want these?
    -- use("hrsh7th/cmp-cmdline")
    -- use("uga-rosa/cmp-dictionary")

    -- Snippets
    -- use("L3MON4D3/LuaSnip")
    -- use("saadparwaiz1/cmp_luasnip")
    -- use("rafamadriz/friendly-snippets") -- collection of snippets for all langs

    -- use {
    --   "nvim-neo-tree/neo-tree.nvim",
    --   branch = "v2.x",
    --   requires = {
    --     "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
    --     "MunifTanjim/nui.nvim"
    --   }
    -- }
  end,
  config = {
    display = { open_fn = require("packer.util").float },
    max_jobs = 10,
    -- disable for now (https://github.com/wbthomason/packer.nvim/issues/201)
    -- Move to lua dir so impatient.nvim can cache it
    -- compile_path = vim.fn.stdpath("cache") .. "/lua/packer_compiled.lua",
    -- compile_on_sync = true
  },
})
