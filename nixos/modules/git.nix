{
  config,
  pkgs,
  lib,
  ...
}: let
  gitUsers = ["sten"];
  gitUserName = "r181104";
  gitUserEmail = "sten181104@gmail.com";
  gitSigningKeyRelative = ".ssh/id_rsa";
in {
  environment.systemPackages = with pkgs; [
    git
    delta
    neovim
  ];
  system.activationScripts.gitConfigUsers = lib.mkAfter ''
        for u in ${lib.concatStringsSep " " gitUsers}; do
          # skip root if accidentally included
          if [ "$u" = "root" ]; then continue; fi

          # get home directory dynamically
          userHome=$(getent passwd "$u" | cut -d: -f6)
          if [ -z "$userHome" ]; then
            echo "Warning: user $u not found, skipping .gitconfig"
            continue
          fi

          gitConfigFile="$userHome/.gitconfig"

          # create .gitconfig
          mkdir -p "$userHome"
          cat > "$gitConfigFile" <<EOF
    [user]
        name = ${gitUserName}
        email = ${gitUserEmail}
        signingkey = \$HOME/${gitSigningKeyRelative}

    [core]
        editor = nvim
        pager = delta
        autocrlf = input

    [interactive]
        diffFilter = delta --color-only

    [delta]
        navigate = true
        line-numbers = true
        side-by-side = true
        syntax-theme = Dracula
        hyperlinks = true

    [diff]
        colorMoved = default

    [init]
        defaultBranch = main

    [pull]
        rebase = true

    [push]
        default = current

    [color]
        ui = auto
    EOF

          # set ownership and permissions
          chown "$u:users" "$gitConfigFile"
        done
  '';
}
