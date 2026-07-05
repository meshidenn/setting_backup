---
name: git-issue-flow
description: GitHub の issue と branch をセットで作成し Development 欄に紐付ける標準手順。新しい機能・実験・修正の作業を始めるとき、「issue を作って」「ブランチを切って」「作業を始めたい」で発火。
---

# Git Issue Flow

新しい作業単位を始めるときの標準手順。issue と branch は必ずセットで作り、GitHub の Development 欄に紐付ける。

## 手順

1. issue を作成する:
   ```bash
   gh issue create --title "<簡潔なタイトル>" --body "<背景と完了条件>"
   ```
2. branch 名を決める: `{project_name or feature/exp}/<issue_number>-<descriptive-words>`
   - 例: `feature/12-add-retry-logic`、`exp/5-fix-timeout-handling`
   - 既存リポジトリに branch 命名規約があればそちらを優先する
3. issue と branch を紐付けて作成する（Development 欄に反映される）:
   ```bash
   gh issue develop <issue_number> -n <branch_name> -b <base_branch>
   git switch <branch_name>
   ```

## コミット規約（このフローで作った branch 上で）

- メッセージ形式: `#<issue_number> <type>:<descriptive_words>`
  - type: fix, add, del, update, refactor など
  - 例: `#12 add:max_retries_param`
- 1 論理単位 = 1 コミット
- push は明示承認があるまで行わない
