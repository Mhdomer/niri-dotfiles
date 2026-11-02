function dotenv -d "Source environment variables from a file or .env into Fish session" -a file
    set -l env_file

    if test -z "$file"
        set env_file .env
    else
        set env_file $file
    end

    if not test -f "$env_file"
        echo "Error: $env_file not found" >&2
        return 1
    end

    set -l count 0
    while read -l line
        if test -n "$line"; and not string match -qr '^\s*#' -- "$line"
            set -l parts (string split -m 1 '=' -- "$line")
            if test (count $parts) -eq 2
                set -l var_name (string trim "$parts[1]")
                set -l var_val (string trim -c "'\"" "$parts[2]")
                set -gx $var_name $var_val
                set count (math $count + 1)
            end
        end
    end <"$env_file"
    echo "✅ Loaded $count environment variables from $env_file"
end
