{
  config,
  pkgs,
  ...
}: {
  # === User info ===
  home.username = "sten";
  home.homeDirectory = "/home/sten";

  # === Enable Home Manager modules ===
  programs.home-manager.enable = true;
  #
  # # === Terminal ===
  # programs.tmux.enable = true;
  # programs.tmux.plugins = [
  #   {
  #     name = "tmux-plugins/tpm";
  #   }
  #   {
  #     name = "tmux-plugins/tmux-sensible";
  #   }
  # ];
  #
  # # === Editor ===
  # programs.neovim.enable = true;
  # programs.neovim.vimAlias = true;
  # programs.neovim.extraConfig = ''
  #   set number
  #   syntax on
  #   set mouse=a
  # '';

  # === Git config ===
  programs.git = {
    enable = true;
    userName = "r181104";
    userEmail = "sten181104@gmail.com";
  };

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

  # === X11 / Window Manager ===
  # programs.xserver.enable = true;
  # programs.xserver.windowManager.bspwm.enable = true;
  # programs.xserver.desktopManager.plasma5.enable = false;
  #
  # # === Fonts & Cursor ===
  # fonts.fonts = with pkgs; [
  #   noto-fonts
  #   noto-fonts-cjk
  #   noto-fonts-emoji
  # ];
  # xsession.cursor = "Bibata-Modern-Ice";
  #
  # # === Environment variables ===
  # home.sessionVariables = {
  #   EDITOR = "nvim";
  #   LANG = "en_IN.UTF-8";
  #   LC_ALL = "en_IN.UTF-8";
  # };
  #
  # # === Notifications ===
  # programs.dunst.enable = true;

  # === Misc ===
  home.file.".bashrc".text = ''
      if [ -f ~/.bashrc ]; then
      source ~/.bashrc
    fi
  '';
}
