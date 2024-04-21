#!/usr/bin/env fish

if test -z "$argv[1]"
    echo "Please provide a pattern to match"
    exit 1
end

set pattern $argv[1]

set matches (rg -g '*.unica' --files-with-matches "$pattern")

if test (count $matches) -ge 1
    rg '^\s*[}]' $matches
end

