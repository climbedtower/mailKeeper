#!/usr/bin/env bash
set -eu

# --- 設定 ---
MODE=${1:-create}                 # デフォルトは create、--update で更新モード
REPO=$(gh repo view --json owner,name -q ".owner.login + \"/\" + .name") # リポジトリ名を自動取得
LABELS="step,todo"
CSV_FILE="./.github/scripts/steps.csv"
# --- 設定ここまで ---

while IFS=, read -r id title body; do
  [[ "$id" == "id" ]] && continue           # ヘッダー行は無視

  # Issue が既に存在するか検索
  ISSUE_NUM=$(gh issue list --repo "$REPO" \
               --search "[$id]" --json number \
               -q '.[0].number' || true)

  if [[ -z "$ISSUE_NUM" ]]; then
    # --- 未存在：新規作成 ---
    gh issue create \
      --repo "$REPO" \
      --title "[$id] $title" \
      --body  "$(echo -e "$body")" \
      --label "$LABELS"
  elif [[ "$MODE" == "--update" ]]; then
    # --- 既存：本文を比較して違えば更新 ---
    CURR=$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json body -q .body)
    if [[ "$CURR" != "$(echo -e "$body")" ]]; then
      gh issue edit "$ISSUE_NUM" --repo "$REPO" --body "$(echo -e "$body")"
    fi
  fi
done < .github/scripts/steps.csv
