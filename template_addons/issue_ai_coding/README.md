# AIコーディングアシスタント ワークフローセット

このアドオンは、Anthropic社のAIモデル「Claude」とGitHub Actionsを連携させ、コードレビュー、PRの自動マージ、対話によるタスク実行、次のタスクへの自動着手といった一連の開発プロセスを自動化するためのワークフローセットです。

面倒な手作業をAIに任せることで、開発チームはより創造的な作業に集中でき、開発サイクルを高速化します。

## 💡 具体的なユースケース

-   **自動コードレビュー**: Pull Requestを作成すると、Claudeが自動でコードをレビューし、改善点を提案します。
-   **対話によるアシスト**: IssueやPRのコメントで `@claude` とメンションするだけで、仕様の相談、リファクタリング案の提示、テストコードの生成などを依頼できます。
-   **CI/CD連携の自動化**: レビューが完了し、すべてのチェックをパスしたPRに `automerge` ラベルを付与すると、自動的にマージが実行されます。
-   **継続的なタスク進行**: ひとつのPRがマージされると、バックログ（`todo` ラベルの付いたIssue）から次のタスクを自動的に進行中（`doing`）にし、開発の勢いを維持します。

## 導入方法

### 前提条件

-   [Anthropic ClaudeのAPIキー](https://console.anthropic.com/settings/keys) を取得していること。

### 手順

1.  **シークレットと変数の設定**
    あなたのGitHubリポジトリの `Settings` > `Secrets and variables` > `Actions` に移動し、以下のシークレットと変数を登録します。

    -   **Secrets**
        -   **Name**: `ANTHROPIC_API_KEY`
        -   **Secret**: あなたのAnthropic APIキー

    -   **Variables** (任意)
        -   **Name**: `CLAUDE_MODEL`
        -   **Value**: `claude-3-5-sonnet-20240620` (利用したいClaudeのモデル名)
        -   **Name**: `MERGE_METHOD`
        -   **Value**: `squash` (PRのマージ方法: `merge`, `rebase` も選択可)

2.  **ワークフローファイルの設置**
    以下のコマンドをあなたのプロジェクトのルートディレクトリで実行し、必要なワークフローファイルを `.github/workflows/` ディレクトリにダウンロードします。

    ```bash
    # ワークフロー用のディレクトリを作成
    mkdir -p .github/workflows

    # GitHubから直接ワークフローファイルをダウンロード
    BASE_URL="https://raw.githubusercontent.com/あなたのユーザー名/あなたのリポジトリ名/main/template_addons/issue_ai_coding"
    curl -L -o .github/workflows/claude-review.yml $BASE_URL/claude-review.yml
    curl -L -o .github/workflows/claude.yml $BASE_URL/claude.yml
    curl -L -o .github/workflows/auto-merge.yml $BASE_URL/auto-merge.yml
    curl -L -o .github/workflows/next-step.yml $BASE_URL/next-step.yml
    ```
    **※注意**: 上記コマンド内の `あなたのユーザー名/あなたのリポジトリ名` の部分は、このアドオンが置かれている実際のURLに修正してください。

## 🛠️ 使い方

導入が完了すれば、以下の操作を行うだけで各機能が自動的に動作します。

-   **自動レビューを開始する**: Pull Requestを作成または更新します。
-   **Claudeに作業を依頼する**: IssueやPRのコメントで `@claude [依頼内容]` とメンションします。（例: `@claude この関数のテストコードを書いて`）
-   **PRを自動マージする**: 自動マージしたいPRに `automerge` ラベルを付与します。
-   **次のタスクに進む**: PRをマージします。

## ⚙️ 仕組み

このアドオンは、4つの独立したGitHub Actionsワークフローで構成されています。

-   **`claude-review.yml`**: PRが作成されると発火。`git diff` で変更内容を取得し、Claude APIに送信してレビュー結果をPRコメントに投稿します。
-   **`claude.yml`**: `@claude` というメンションをトリガーに発火。コメント内容と関連するPRの文脈（タイトル、本文、差分）をClaude APIに送信し、結果をコメントで返信します。
-   **`auto-merge.yml`**: `automerge` ラベルをトリガーに発火。`peter-evans/enable-pull-request-automerge` アクションを利用して、PRの自動マージを有効化します。
-   **`next-step.yml`**: PRがマージされると発火。`gh` コマンドを使って `step` と `todo` ラベルを持つIssueを検索し、次の担当者をアサインしてラベルを `doing` に更新します。

## 📜 注意事項

-   **API利用料金**: Claude APIの利用には、別途料金が発生する場合があります。Anthropicの料金体系を確認してください。
-   **レビュー対象の限定**: `claude-review.yml` は、デフォルトで `src/` ディレクトリ配下の変更のみをレビュー対象としています。対象を変更したい場合は、ワークフローファイル内の `paths` の値をプロジェクトに合わせて修正してください。
-   **自動マージの方式**: `auto-merge.yml` のデフォルトのマージ方式は `squash` です。変更したい場合は、リポジトリの変数 `MERGE_METHOD` の値を `merge` や `rebase` に修正してください。

## 🆚 よくある質問 (FAQ)

-   **Q**: ClaudeのAIモデルを変更したいのですが？
    **A**: リポジトリの `Settings > Secrets and variables > Actions` で、変数 `CLAUDE_MODEL` の値を、利用したいモデル名（例: `claude-3-opus-20240229`）に変更してください。この変数を設定しない場合、ワークフローに記述されたデフォルトのモデルが使用されます。

-   **Q**: 特定のPRで自動レビューを無効にしたい場合はどうすればよいですか？
    **A**: PRのタイトルや本文に `[skip-review]` のような特定のキーワードを含め、`claude-review.yml` の `jobs` セクションに `if: "!contains(github.event.pull_request.title, '[skip-review]') && !contains(github.event.pull_request.body, '[skip-review]')"` のような条件を追加することで、特定のPRをスキップできます。

-   **Q**: `next-step.yml` でアサインされるユーザーを変更できますか？
    **A**: はい、`next-step.yml` ファイル内の `--add-assignee` の値を、任意のアサインしたいユーザー名（例: `--add-assignee "some-user"`）に変更してください。
