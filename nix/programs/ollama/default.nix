{
  ...
}:
{
  nixDarwinModules = [
    {
      # nixpkgs 版 ollama は MLX が無効化されている
      # (pkgs/by-name/ol/ollama/package.nix の `-DOLLAMA_MLX_BACKENDS=""`)。
      # MLX Metal のビルドには Xcode 同梱の metal シェーダコンパイラが必要で、
      # 再配布不可のため nixpkgs の apple-sdk には含まれず、有効化できない。
      # Homebrew は MLX 本体を別 formula `mlx-c` のボトルとして配布しているため、
      # MLX を使うにはこちらを採用する。
      homebrew.brews = [
        {
          name = "ollama";
          restart_service = "changed";
        }
      ];
    }
  ];
}
