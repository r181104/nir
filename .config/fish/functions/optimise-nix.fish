function optimise-nix
    nix-env -q | xargs nix-env -e
    sudo nix-store --gc --print-roots | grep obsolete
end
