# if uname -s | string match -q Darwin
if test -f /System/Library/CoreServices/SystemVersion.plist
    set -x DOTF_OS mac
else
    set -x DOTF_OS linux
end

function dotf-is-mac
    test "$DOTF_OS" = mac
end

function dotf-is-linux
    test "$DOTF_OS" = linux
end
