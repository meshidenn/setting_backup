{ config, pkgs, ... }:

let
  # mkOutOfStoreSymlink の実体パス。repo は ~/dotfiles に clone されている前提
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
in
{
  # home-manager 自身のバージョン互換基準(初回導入時の値から変えない)
  home.stateVersion = "25.05";

  # standalone 運用: home-manager CLI 自身も home-manager が管理する
  programs.home-manager.enable = true;

  # ===== パッケージ(旧 setup.sh のインストール対象) =====
  # starship/fzf/zoxide/mise は下の programs.* が同時にパッケージも入れる
  home.packages = with pkgs; [
    uv
    bun
    gh
    jq
  ];

  # ~/.local/bin(AI CLI 群のインストール先)は PATH に残す
  home.sessionPath = [ "$HOME/.local/bin" ];

  # ===== bash(旧 bash/ stow パッケージ。旧 Linux 機の残骸は linux.nix に隔離) =====
  programs.bash = {
    enable = true;
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    shellOptions = [ "histappend" "checkwinsize" ];
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      g = "git";
      k = "kubectl";
      gitpp = "git pull -r --au && git push";
      grep = "grep --color=auto";
    };
    initExtra = ''
      # vi キーバインド
      set -o vi
    '';
  };

  # ===== プロンプト・シェル統合(bash への init 埋め込みは各 programs.* が自動生成) =====
  programs.starship.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.mise.enable = true; # ランタイム管理は第1段階では mise のまま(Nix 移行は第2段階)

  # starship 設定は素材ファイルをそのまま配置
  xdg.configFile."starship.toml".source = ./files/starship.toml;

  # ===== tmux(旧 tmux/ stow パッケージの5行を移植) =====
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g prefix C-q
      unbind C-b
      set-option -g default-terminal screen-256color
      set-option -g default-shell /bin/bash
      set -g terminal-overrides 'xterm:colors=256'
      set -g default-command /bin/bash
    '';
  };

  # ===== git(旧 git/ stow パッケージ) =====
  programs.git = {
    enable = true;
    userName = "meshidenn";
    userEmail = "mesitahiro@hotmail.com";
    aliases = {
      gr = "log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'";
      st = "status";
      cm = "commit";
      cmm = "commit -m";
      a = "add";
      au = "add -u";
      b = "branch";
      c = "checkout";
      # Untracked files を表示せず、not staged と staged だけの状態を出力する
      stt = "status -uno";
      # 行ごとの差分じゃなくて、単語レベルでの差分を色付きで表示する
      difff = "diff --word-diff";
    };
    extraConfig = {
      core.editor = "vim";
      # /opt/homebrew ハードコードをやめ、PATH 上の gh に解決させる
      credential."https://github.com".helper = [ "" "!gh auth git-credential" ];
      credential."https://gist.github.com".helper = [ "" "!gh auth git-credential" ];
    };
  };
  xdg.configFile."git/ignore".source = ./files/git-ignore;

  # ===== mutable 系 symlink(Phase 3 で有効化) =====
  # ⚠️ これらは実行時に書き込みが発生するため read-only の store symlink 化は厳禁。
  #    mkOutOfStoreSymlink で「repo 実体への書き込み可能 symlink」として張る(Stow と同じ挙動)。
  #    正本原則: エージェント指示の正本は agents/.agents/AGENTS.md のみ。
  # TODO(Phase 3): stow -D claude agents gemini と同時に以下のコメントを解除して switch する
  # home.file.".claude".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/claude/.claude";
  # home.file.".agents".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/agents/.agents";
  # home.file.".gemini".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/gemini/.gemini";
  # home.file.".codex/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/AGENTS.md";
}
