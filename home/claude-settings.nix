{ config, pkgs, lib, ... }:

let
  claudeDir = "${config.home.homeDirectory}/dotfiles/claude/.claude";
  profile = config.dotfiles.claudeSettingsProfile;
in
{
  # Claude Code の settings.json はマシン種別で中身が異なる(個人=サブスク、会社=Vertex AI)。
  # 共有の単一ファイルだと branch checkout で生きた設定が入れ替わる事故が起きるため、
  # base + profile overlay から activation 時に生成する(生成物は git 追跡外)。
  options.dotfiles.claudeSettingsProfile = lib.mkOption {
    type = lib.types.enum [ "personal" "work" ];
    default = "personal";
    description = "生成する Claude Code settings.json のプロファイル(会社マシンでは work を指定)";
  };

  # jq の * はオブジェクトを再帰マージ、配列・スカラーは上書き。
  # そのため配列(permissions 等)は base 側だけに置く運用とする。
  # tmp に書いてから mv するのは、生成中に Claude Code が読む可能性への対策。
  config.home.activation.generateClaudeSettings =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' \
        "${claudeDir}/settings.base.json" \
        "${claudeDir}/settings.${profile}.json" \
        > "${claudeDir}/settings.json.tmp" \
        && mv "${claudeDir}/settings.json.tmp" "${claudeDir}/settings.json"
    '';
}
