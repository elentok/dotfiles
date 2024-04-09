#!/usr/bin/env fish

if ! type -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

set pkgs patrickf1/fzf.fish

for pkg in $pkgs
    echo -n "Checking $pkg... "
    if fisher list | grep -q $pkg
        echo "already installed."
    else
        echo "installing..."
        fisher install $pkg

    end
end
