if dotf-is-linux
    if type --quiet xclip
        alias pbcopy 'xclip -selection clipboard -in'
        alias pbpaste 'xclip -selection clipboard -out'
    else if type --quiet xsel
        alias pbcopy 'xsel --clipboard --input'
        alias pbpaste 'xsel --clipboard --output'
    end
end

alias pbc pbcopy
alias pbp pbpaste
