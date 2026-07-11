{ ... }:

{
  # macOS 差分。通知 hook は claude/.claude/settings.json 内の
  # command -v 実行時分岐で対応済みのため、ここでは shell 環境のみ扱う

  # Homebrew を login shell に読み込む(nix 管理外のツールも併用するため)
  programs.bash.profileExtra = ''
    eval "$(/opt/homebrew/bin/brew shellenv bash)"
  '';

  # macOS の /bin/bash は 3.2 で、home-manager の completion ブロック([[ -v ]])が
  # 動かないため無効化(旧構成でも Mac では completion は読み込まれていなかった)
  programs.bash.enableCompletion = false;
}
