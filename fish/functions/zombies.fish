function zombies -d "Find and show parent processes of zombie (defunct) processes"
    set -l ppid_list (ps -A -ostat,ppid | grep -e '[zZ]' | awk '{ print $2 }' | sort -u)
    if test -n "$ppid_list"
        echo "🧟 Detected zombie processes! Parent processes responsible:"
        ps -f -p $ppid_list
    else
        echo "✅ No zombie (defunct) processes found on the system."
    end
end
