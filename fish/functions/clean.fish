function clean -d "Clean system package caches, build caches, and show disk usage"
    echo "🧹 Cleaning Pacman cache..."
    if command -v paccache >/dev/null
        sudo paccache -rk1
        sudo paccache -ruk0
    end

    if command -v paru >/dev/null
        paru -Sc --noconfirm
    end

    if command -v cargo-cache >/dev/null
        cargo cache -a
    end

    if command -v yarn >/dev/null
        yarn cache clean 2>/dev/null
    end

    if command -v pnpm >/dev/null
        pnpm store prune 2>/dev/null
    end

    if command -v pip >/dev/null
        pip cache purge 2>/dev/null
    end

    if command -v docker >/dev/null; and systemctl is-active --quiet docker
        echo "🐳 Pruning unused Docker artifacts..."
        docker system prune -f 2>/dev/null
    end

    if command -v podman >/dev/null
        podman system prune -f 2>/dev/null
    end

    echo ""
    echo "📊 Disk Usage Summary:"
    if command -v duf >/dev/null
        duf
    else
        df -h / /mnt/data
    end
end
