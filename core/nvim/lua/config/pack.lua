local gh = function(repo) return "https://github.com/" .. repo end

local stuff_path = vim.fn.expand("~/dev/nvim/stuff.nvim")
local has_local_stuff = vim.uv.fs_stat(stuff_path) ~= nil

if has_local_stuff then
  local local_pack_dir = vim.fn.stdpath("config") .. "/pack/local/opt"
  local local_stuff_pack = local_pack_dir .. "/stuff.nvim"

  if not vim.uv.fs_stat(local_stuff_pack) then
    vim.fn.mkdir(local_pack_dir, "p")
    local ok, err = vim.uv.fs_symlink(stuff_path, local_stuff_pack)
    if not ok then
      vim.notify(("Failed to link local stuff.nvim checkout: %s"):format(err), vim.log.levels.ERROR)
    end
  end

  vim.cmd(vim.v.vim_did_init == 0 and "packadd! stuff.nvim" or "packadd stuff.nvim")
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

local pack_specs = {
  gh("nvim-mini/mini.icons"),
  gh("SmiteshP/nvim-navic"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  gh("kkharji/sqlite.lua"),
  gh("mason-org/mason.nvim"),

  { src = gh("catppuccin/nvim"), name = "catppuccin" },
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
  gh("uga-rosa/ccc.nvim"),
  gh("stevearc/conform.nvim"),
  gh("elentok/encrypt.nvim"),
  gh("folke/flash.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("MagicDuck/grug-far.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("nvim-lualine/lualine.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("rubixninja314/vim-mcfunction"),
  gh("nvim-mini/mini.bracketed"),
  gh("nvim-mini/mini.pairs"),
  gh("nvim-mini/mini.move"),
  gh("obsidian-nvim/obsidian.nvim"),
  gh("stevearc/oil.nvim"),
  gh("MeanderingProgrammer/render-markdown.nvim"),
  gh("Wansmer/sibling-swap.nvim"),
  gh("mrjones2014/smart-splits.nvim"),
  gh("folke/snacks.nvim"),
  { src = gh("kylechui/nvim-surround"), version = vim.version.range("^4.0.0") },
  gh("folke/which-key.nvim"),
  gh("ptdewey/yankbank-nvim"),
}

if not has_local_stuff then table.insert(pack_specs, gh("elentok/stuff.nvim")) end

vim.pack.add(pack_specs, { confirm = false })
