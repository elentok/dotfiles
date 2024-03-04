if uname -s | string match -q Darwin
    set -x OS mac
else
    set -x OS linux
end

function dotf-is-mac
    test "$OS" = mac
end

function dotf-is-linux
    test "$OS" = linux
end
