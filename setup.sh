#!/bin/bash
# dotfiles ブートストラップ
# 設定・パッケージの実体は home-manager (flake) が管理する。
# このスクリプトは (1) Nix の案内 (2) home-manager 適用 (3) AI CLI 群のインストールのみ行う。
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ===== 1. Nix (Determinate Systems 版。admin 権限が必要なため手動実行を促す) =====
if ! command -v nix &>/dev/null && [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
    echo "Nix が見つかりません。先に以下を実行してください:"
    echo "  curl -fsSL https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi
# このシェルに nix の PATH がなければ読み込む
command -v nix &>/dev/null || . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# ===== 2. home-manager 適用 =====
# ホスト名等での自動判別はせず、明示指定(デフォルトは OS で出し分け)
if [ -n "$1" ]; then
    PROFILE="$1"
elif [ "$(uname)" = "Darwin" ]; then
    PROFILE="hiroki-iida@mac"
elif [ "$(uname -m)" = "aarch64" ]; then
    PROFILE="hiroki@linux-aarch64"
else
    PROFILE="hiroki@linux"
fi
echo "Applying home-manager configuration: ${PROFILE}"
# -b backup: 既存ファイルと衝突したら <name>.backup に退避して続行(新規マシンでの初回適用対策)
nix run home-manager -- switch --flake "${DOTFILES_DIR}#${PROFILE}" -b backup

# ===== 3. AI CLI 群(自己アップデート機構を持つため Nix 管理外) =====
echo "setup claude code"
if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "claude already installed, skipping"
fi

echo "setup codex"
if ! command -v codex &>/dev/null; then
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
else
    echo "codex already installed, skipping"
fi

echo "setup antigravity cli"
if ! command -v agy &>/dev/null; then
    curl -fsSL https://antigravity.google/cli/install.sh | bash
else
    echo "antigravity already installed, skipping"
fi

echo "Setup complete!"
