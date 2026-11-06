function fix-data --description "Clear NTFS dirty bit and safely mount /mnt/data"
    set -l uuid "8A7E2D037E2CEA21"
    set -l dev_path "/dev/disk/by-uuid/$uuid"

    if test -e "$dev_path"
        set -l real_dev (readlink -f "$dev_path")
        echo "🔧 Target partition: $real_dev (UUID: $uuid)"
        
        # 1. Clear dirty flag using ntfsfix
        echo "🧹 Clearing NTFS dirty flag with ntfsfix..."
        sudo ntfsfix -d "$real_dev"
        
        # 2. Mount /mnt/data
        echo "📂 Mounting /mnt/data..."
        sudo mount /mnt/data 2>/dev/null
        if test $status -ne 0
            # Fallback direct mount with force if fstab mount was blocked
            sudo mount -t ntfs3 -o uid=1000,gid=1000,dmask=022,fmask=133,force,windows_names "$real_dev" /mnt/data
        end

        # 3. Verify mount
        if mountpoint -q /mnt/data
            echo "✅ /mnt/data mounted successfully!"
            df -h /mnt/data
        else
            echo "❌ Failed to mount /mnt/data. Check dmesg or journalctl."
        end
    else
        echo "❌ Partition with UUID $uuid not found. Check if NVMe drive is detected."
    end
end
