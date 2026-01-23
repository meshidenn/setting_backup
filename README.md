# dotfiles

GNU Stow を使った dotfiles 管理

## セットアップ

```bash
git clone git@github.com:meshidenn/setting_backup.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## 構成

```
dotfiles/
├── bash/          # .bashrc, .bash_profile, .profile
├── tmux/          # .tmux.conf
├── git/           # .config/git/config, ignore
├── starship/      # .config/starship.toml
└── claude/        # .claude/
```

## 手動で stow する場合

```bash
# 全て有効化
stow bash tmux git starship claude

# 個別に有効化
stow bash

# 無効化
stow -D bash
```

## インストールされるツール

| ツール | 説明 |
|--------|------|
| [mise](https://mise.jdx.dev/) | ランタイムバージョン管理 |
| [starship](https://starship.rs/) | シェルプロンプト |
| [fzf](https://github.com/junegunn/fzf) | ファジーファインダー |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | スマートな cd |
| [uv](https://github.com/astral-sh/uv) | Python パッケージマネージャ |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | Kubernetes CLI |
| [Claude Code](https://claude.ai/claude-code) | Claude CLI |
| [Gemini CLI](https://github.com/google/gemini-cli) | Gemini CLI |
