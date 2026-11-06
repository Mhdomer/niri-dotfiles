function clean -d "Clean system package caches, build caches, and show disk usage"
    if test -x ~/.local/bin/clean
        ~/.local/bin/clean $argv
    else
        command clean $argv
    end
end
