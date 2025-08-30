function jvp --description 'jump to neovim plugin'
    set plugin (cd ~/.local/share/nvim/lazy && command ls -1 | tv)
    cd $plugin
end
