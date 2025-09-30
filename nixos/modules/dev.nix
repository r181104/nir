{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Development languages & tools ===
    lazygit
    gcc
    rustup
    go
    python314
    pipx
    uv
    jdk
    maven
    gradle
    nodePackages.nodejs
    gnumake
    pkg-config

    # === Language Server Protocols ===
    pyright
    lua-language-server
    haskellPackages.ghcide
    jdt-language-server
    vtsls
    tailwindcss-language-server

    # === Formatters / Linters ===
    stylua
    black
    isort
    haskellPackages.hindent
    gofumpt
    goimports-reviser
    shfmt
    clang-tools
    sqlfluff
    yamlfmt
    prettierd
    google-java-format
    alejandra
    jq
  ];
}
