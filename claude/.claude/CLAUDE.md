# Global Instructions

## Communication
- Always respond in Japanese
- Write code comments in Japanese
- Technical terms can remain in English

## Coding Style
- Follow existing code style when modifying existing code
- For new or early-stage projects: write readable code with proper hierarchy, naming, and separation of concerns
- Primary language: Python

## Commit Granularity
- One commit per logical unit: "one reason to change" = one commit
- Examples of what belongs together:
  - Script + docs recording its results → 1 commit
  - Multiple configs with the same purpose → 1 commit
- Examples of what should be split:
  - Bug fix + new feature → 2 commits
  - Script + unrelated config → 2 commits

## Git Rules
- Commit message format: `#<issue_number> <type>:<descriptive_words>`
  - type: fix, add, del, update, refactor, etc.
  - Example: `#12 add:max_retries_param`
  - Example: `#5 fix:timeout_error_handling`
- Branch naming: `{project_name or feature/exp}/<issue_number>-<descriptive-words>`
  - Example: `feature/12-add-retry-logic`
  - Example: `exp/5-fix-timeout-handling`
  - Follow existing branch naming conventions if present
- Create branch together with issue
- After creating an issue and branch, always link them with:
  `gh issue develop <issue_number> -n <branch_name> -b <base_branch>`
  This populates the "Development" section on the GitHub issue page.

## Strict Rules (MUST follow)
- NEVER push without explicit approval
- Refactoring: only when instructed, or propose and wait for approval
- Always run tests and verify behavior (except physically impossible cases like LLM inference)
- ALWAYS present a Plan before implementation, get approval, then execute in Phases

## Forbidden File Operations
- NEVER commit or edit `.env` files
- NEVER delete large data directories (`outputs/`, `containers/`, `dataset/`) without explicit approval

## Available CLI Tools (System-wide)
- `gws` — Google Workspace CLI (Drive, Sheets, Gmail, Calendar等に直接アクセス)
  - PATH: `~/.nodenv/versions/22.22.1/bin/gws`
  - 認証: `gcloud auth login --enable-gdrive-access` で Drive スコープ追加済み
  - 例: `gws drive files list --params '{"q": "..."}' --format table`
  - 例: `gws drive files get --params '{"fileId": "...", "alt": "media"}'`
  - 例: `gws sheets spreadsheets get --params '{"spreadsheetId": "..."}'`
- `wandb` — WandB CLI (`uv tool install wandb`)
  - PATH: `~/.local/bin/wandb`（PATH追加が必要な場合あり）
  - GraphQL API: `.env` の `WANDB_API_KEY` + `urllib.request` で `https://api.wandb.ai/graphql` も可
- `gcloud` — Google Cloud SDK（認証トークン取得、GCP操作）
