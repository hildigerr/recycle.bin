#!/bin/sh
# List all system users (UID < 1000) and check if they belong to an active sysusers config
cut -d: -f1,3 /etc/passwd | while IFS=: read -r user uid; do
    if [ "$uid" -lt 1000 ] && [ "$uid" -ne 0 ]; then
        # Check if any installed package owns a sysusers file mentioning this user
        if ! grep -qsq "^u $user" /usr/lib/sysusers.d/*.conf; then
            printf "Potential Orphan: %s (UID: %s)\n" "$user" "$uid"
        fi
    fi
done
