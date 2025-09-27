function clean-nix
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5
    sudo nix-store --gc --print-roots | grep /tmp | awk '{print $1}' | xargs rm -f
end
