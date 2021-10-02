-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/david/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/david/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/david/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/david/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/david/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["calendar.vim"] = {
    commands = { "Calendar" },
    loaded = false,
    needs_bufread = false,
    path = "/home/david/.local/share/nvim/site/pack/packer/opt/calendar.vim"
  },
  ["file-line"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/file-line"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  fzf = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["goyo.vim"] = {
    commands = { "Goyo" },
    loaded = false,
    needs_bufread = false,
    path = "/home/david/.local/share/nvim/site/pack/packer/opt/goyo.vim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/impatient.nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["monokai.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/monokai.nvim"
  },
  neogit = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plantuml-syntax"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/plantuml-syntax"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["presenting.vim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/presenting.vim"
  },
  ["replace-all.vim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/replace-all.vim"
  },
  ["splitjoin.vim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/splitjoin.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["togglr.vim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vtogglr\frequire\0" },
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/togglr.vim"
  },
  ["vaffle.vim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vaffle.vim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-abolish"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-dispatch"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-easy-align"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-eunuch"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-gnupg"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-gnupg"
  },
  ["vim-grepper"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-grepper"
  },
  ["vim-indent-guides"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-indent-guides"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-indent-object"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-signify"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-signify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-unimpaired"
  },
  ["vim-visual-star-search"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/vim-visual-star-search"
  },
  ["writegood.vim"] = {
    loaded = true,
    path = "/home/david/.local/share/nvim/site/pack/packer/start/writegood.vim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: togglr.vim
time([[Config for togglr.vim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vtogglr\frequire\0", "config", "togglr.vim")
time([[Config for togglr.vim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Goyo lua require("packer.load")({'goyo.vim'}, { cmd = "Goyo", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Calendar lua require("packer.load")({'calendar.vim'}, { cmd = "Calendar", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
