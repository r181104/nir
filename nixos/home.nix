{
  config,
  pkgs,
  ...
}: {
  # === User info ===
  home.username = "sten";
  home.homeDirectory = "/home/sten";

  # === Enable Home Manager ===
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";

  # === Shell setup ===
  # programs.zsh.enable = true;
  # programs.zsh.ohMyZsh.enable = true;
  # programs.zsh.ohMyZsh.theme = "agnoster";
  # programs.zsh.ohMyZsh.plugins = [ "git" "z" "extract" ];

  # === Git config ===
  programs.git.enable = true;
  programs.git.userName = "r181104";
  programs.git.userEmail = "sten181104@gmail.com";

  # === Packages ===
  # home.packages = with pkgs; [
  #   wget
  #   curl
  #   git
  #   htop
  #   neovim
  #   ripgrep
  #   fzf
  #   bat
  #   exa
  #   tmux
  #   zoxide
  # ];
  #
  # === Terminal multiplexer ===
  # programs.tmux.enable = true;
  # programs.tmux.plugins = [
  #   { name = "tmux-plugins/tpm"; }
  #   { name = "tmux-plugins/tmux-sensible"; }
  # ];

  # === Editor ===
  # programs.neovim.enable = true;
  # programs.neovim.vimAlias = true;
  # programs.neovim.extraConfig = ''
  #   set number
  #   syntax on
  #   set mouse=a
  # '';

  # === Environment variables ===
  # home.sessionVariables = {
  #   EDITOR = "nvim";
  #   LANG = "en_IN.UTF-8";
  #   LC_ALL = "en_IN.UTF-8";
  # };

  # === Fonts & Cursor ===
  # fonts.fonts = with pkgs; [
  #   noto-fonts
  #   noto-fonts-cjk
  #   noto-fonts-emoji
  # ];
  # xsession.cursor = "Bibata-Modern-Ice";
  #
  # # === Notifications ===
  # programs.dunst.enable = true;

  # === Misc / Bash fix ===
  home.file.".bashrc.local".text = ''
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
        fi
  '';
}
