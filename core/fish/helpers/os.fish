#!/usr/bin/env fish

# Helper methods for identifying OS and Distro.

if test (uname -s) = Darwin
    set -gx OS mac
else
    set -gx OS linux
end

function dotf-is-mac
    test $OS = mac
end

function dotf-is-linux
    test $OS = linux
end
