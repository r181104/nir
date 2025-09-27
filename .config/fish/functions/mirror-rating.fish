function mirror-rating
    if type -q reflector
        # Generate mirrorlist for IN, SG, MY using HTTPS, latest 20, sort by rate, keep fastest 10
        sudo reflector \
            --country 'IN,SG,MY' \
            --protocol https \
            --latest 20 \
            --sort rate \
            --fastest 10 \
            --save /etc/pacman.d/mirrorlist

        # Refresh pacman database
        sudo pacman -Syy
    else
        echo "REFLECTOR NOT INSTALLED. GO AND INSTALL IT FIRST."
    end
end

# function mirror-rating
#     set -l mirrorlist /etc/pacman.d/mirrorlist
#     set -l backup /etc/pacman.d/mirrorlist.bak
#
#     echo "  Backing up current mirrorlist → $backup"
#     sudo cp $mirrorlist $backup
#
#     echo
#     echo "  Select mirror scope:"
#     echo "1) India only"
#     echo "2) India + nearby (Singapore, Japan, Hong Kong)"
#     read -l choice
#
#     switch $choice
#         case 1
#             set countries IN
#         case 2
#             set countries IN,SG,JP,HK
#         case '*'
#             echo "  Invalid choice. Aborting."
#             return 1
#     end
#
#     echo
#     echo "  Fetching fastest mirrors for: $countries"
#     rate-mirrors --entry-country=$countries --protocol=https --max-mirrors-to-output=20 arch | sudo tee $mirrorlist
#
#     echo
#     echo "  Refresh pacman databases now? (y/n)"
#     read -l refresh
#     if test "$refresh" = y
#         sudo pacman -Syyu
#     else
#         echo "  Mirrorlist updated. Run 'sudo pacman -Syyu' manually when ready."
#     end
# end
