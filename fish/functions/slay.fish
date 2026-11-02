function slay -d "Kill background processes with excessive CPU usage (>90%)"
    set -l found 0
    top -b -n1 | awk 'NR>7 {if($9 > 90) print $1, $9, $12}' | while read pid cpu command
        echo "🚨 Terminating PID $pid ($command) using $cpu% CPU"
        kill -9 $pid
        set found 1
    end
    if test $found -eq 0
        echo "✅ No runaway processes detected (all processes under 90% CPU)."
    end
end
