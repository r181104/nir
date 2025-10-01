{
  config,
  pkgs,
  ...
}: let
  gitUserName = "r181104";
  gitUserEmail = "sten181104@gmail.com";
  gitSigningKey = "./../../../.ssh/id_rsa";
in {
  environment.systemPackages = with pkgs; [
    git
    delta
    neovim
  ];
  users.defaultUserShell = pkgs.bash;
  users.users.sten = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "sten";
    extraGroups = ["networkmanager" "wheel" "input"];
    packages = with pkgs; [
      fish
      zsh
      tree
      git
      delta
    ];
    dotfiles = {
      ".gitconfig".text = ''
        [user]
            name = ${gitUserName}
            email = ${gitUserEmail}
            signingkey = ${gitSigningKey}

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
      '';
    };
  };
}
