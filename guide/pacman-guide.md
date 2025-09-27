# Arch Linux - pacman.conf Optimization Guide
# Useful tweaks for better performance, control, and usability

============================================
[1] FASTER DOWNLOADS: PARALLEL DOWNLOADS
============================================
Description: Downloads multiple packages simultaneously to speed up installations.

How to enable:
1. Open /etc/pacman.conf:
   sudo nvim /etc/pacman.conf
2. Add under [options]:
   ParallelDownloads = 5
   (5 = number of simultaneous downloads)

Recommended value: 3-6
Too high may cause instability.

============================================
[2] COLORFUL OUTPUT (EASIER TO READ)
============================================
Description: Adds color to pacman's terminal output.

How to enable:
Add under [options]:
Color

============================================
[3] SAVE DISK SPACE: AUTO-CLEAN OLD PACKAGES
============================================
Description: Controls how old packages are kept in /var/cache/pacman/pkg/

Options:
CleanMethod = KeepCurrent   # Keeps only latest version
# OR
CleanMethod = KeepInstalled # Keeps only installed packages

Manual alternative:
Run occasionally:
sudo pacman -Sc

============================================
[4] HOLD BACK PROBLEMATIC UPDATES
============================================
Description: Prevents specific packages from updating.

How to use:
IgnorePkg = package1 package2
Example:
IgnorePkg = linux firefox

============================================
[5] SKIP ENTIRE PACKAGE GROUPS
============================================
Description: Ignores all packages in a group (e.g., gnome)

How to use:
IgnoreGroup = groupname
Example:
IgnoreGroup = gnome

============================================
[6] DISABLE DOWNLOAD TIMEOUTS
============================================
Description: Prevents cancellation of slow downloads.

How to enable:
DisableDownloadTimeout

============================================
[7] ENABLE MULTILIB (32-BIT APPS)
============================================
Description: Allows installing 32-bit software (Steam, Wine, etc.)

How to enable:
1. Uncomment these lines:
   [multilib]
   Include = /etc/pacman.d/mirrorlist
2. Refresh databases:
   sudo pacman -Sy

============================================
[8] FUN EASTER EGG: PAC-MANIMATION
============================================
Description: Replaces progress bar with Pac-Man animation.

How to enable:
ILoveCandy

============================================
[9] VERIFY YOUR CHANGES
============================================
Before using, check for syntax errors:
sudo pacman-conf

============================================
[10] ADDITIONAL TIPS
============================================
- Location: /etc/pacman.conf
- Always make a backup before editing:
  sudo cp /etc/pacman.conf /etc/pacman.conf.bak
- Changes take effect immediately
- For advanced options: man pacman.conf

# End of Guide
# Happy optimizing your Arch Linux system!
