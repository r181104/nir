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

    # === Language Server Protocols ===
    pyright
    lua-language-server
    jdt-language-server
    vtsls
    tailwindcss-language-server

    # === Formatters / Linters ===
    stylua
    black
    isort
    prettier
    gofumpt
    goimports-reviser
    shfmt
    clang
    sqlfluff
    yamlfmt
    prettierd
    google-java-format
    alejandra
    jq
  ];
}
