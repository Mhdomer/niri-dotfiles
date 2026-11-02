function pkgdiff -d "Diff a live system file against its pristine upstream Arch package" -a file
    if test -z "$file" -o not test -f "$file"
        echo "Usage: pkgdiff <path-to-file>"
        return 1
    end

    set -l pkg (pacman -Qo "$file" 2>/dev/null | awk '{print $5}')
    if test -z "$pkg"
        echo "Error: No owning package found for $file"
        return 1
    end

    # Ensure package archive exists in pacman cache
    sudo pacman -Sw --noconfirm "$pkg" >/dev/null

    # Locate latest cached package archive
    set -l cache (command ls -t /var/cache/pacman/pkg/$pkg-*.pkg.tar.zst 2>/dev/null | head -1)
    if test -z "$cache"
        echo "Error: Package archive for $pkg not found in cache"
        return 1
    end

    set -l rel (string replace -r '^/' '' -- "$file")
    echo "🔍 Comparing $file with $pkg ($cache)"

    set -l pkg_tmp (mktemp /tmp/original.XXX.(basename "$file"))
    if not bsdtar -xOf "$cache" "$rel" >"$pkg_tmp" 2>/dev/null
        echo "Error: File $rel not found inside package archive"
        rm -f "$pkg_tmp"
        return 1
    end

    if command -v nvim >/dev/null
        SUDO_EDITOR="nvim -d \"$pkg_tmp\"" sudoedit "$file"
    else
        diff --color=always -u "$pkg_tmp" "$file" | less -R
    end

    rm -f "$pkg_tmp"
end
