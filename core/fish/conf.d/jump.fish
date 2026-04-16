function jvp --description 'jump to neovim plugin'
    set plugins_root ~/.local/share/nvim/site/pack/core/opt/
    set plugin (cd $plugins_root && command ls -1 | fzf)
    cd $plugin
end
