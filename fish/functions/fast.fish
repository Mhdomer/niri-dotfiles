function fast -d "Launch a command under hardware performance power profile"
    if test (count $argv) -eq 0
        echo "Usage: fast <command> [args...]"
        return 1
    end
    powerprofilesctl launch --profile performance $argv
end
