# GitHub Issue一括作成アドオン

このアドオンは、`.github/scripts/steps.csv` ファイルに定義された内容に基づき、現在のGitHubリポジトリにIssueを一括で作成・更新するためのスクリプトを提供します。

スクリプトが実行されたリポジトリを自動で対象とするため、面倒な設定は不要です。

## 💡 具体的なユースケース

-   **プロジェクトのキックオフ**: 新しいリポジトリを作成した直後、開発環境の構築、CI/CDの整備、ドキュメント作成など、決まりきった初期タスクをCSVから一括でIssue登録する。
-   **スプリント計画**: 次のスプリントで対応するユーザーストーリーの一覧をCSVで管理し、スプリント開始時に一括でIssueを生成する。
-   **バグ報告会の議事録から**: 報告されたバグをCSVにまとめ、会終了後にまとめてIssue化する。

## 導入方法

1.  このディレクトリにある `create_issues.sh` と `steps.csv` を、あなたのプロジェクトの `.github/scripts/` ディレクトリにコピーしてください。
2.  もし `.github/scripts/` ディレクトリがなければ、作成してください。

#### ターミナルでの実行例

```bash
# 1. あなたのプロジェクトのルートディレクトリで以下のコマンドを実行してください。

# スクリプト用のディレクトリを作成
mkdir -p .github/scripts

# GitHubから直接スクリプトとサンプルCSVをダウンロード
curl -L -o .github/scripts/create_issues.sh https://raw.githubusercontent.com/yuco/PythonRepoTemplate/main/template_addons/create_issues/create_issues.sh
curl -L -o .github/scripts/steps.csv https://raw.githubusercontent.com/yuco/PythonRepoTemplate/main/template_addons/create_issues/steps.csv

# スクリプトに実行権限を付与
chmod +x .github/scripts/create_issues.sh
```

## 🛠️ 使い方

### 前提条件

-   [GitHub CLI (`gh`)](https://cli.github.com/) がインストールされ、リポジトリへの書き込み権限 (`repo` スコープ) で認証済みであること。

### 1. Issueテンプレートの準備

[`./.github/scripts/steps.csv`](./.github/scripts/steps.csv) ファイルを編集して、作成したいIssueの情報を記述します。`id` はIssueを識別するための一意なキーです。

```csv
id,title,body
0.1,最初のタスク,"これが最初のタスクの本文です。\n複数行も記述できます。"
0.2,次のタスク,"これが次のタスクの本文です。"
```

### 2. 実行

ターミナルで以下のコマンドを実行します。

-   **新規作成**: `steps.csv` に基づいて、まだ存在しないIssueのみを新規作成します。
    ```bash
    bash .github/scripts/create_issues.sh
    ```

-   **更新**: 既存のIssueもチェックし、`steps.csv` の内容と本文が異なれば更新します。
    ```bash
    bash .github/scripts/create_issues.sh --update
    ```

## ⚙️ 仕組み

-   **`create_issues.sh`**:
    -   `gh repo view` で現在のリポジトリ名を取得します。
    -   `gh issue list` でタイトルに含まれる `[id]` を検索し、Issueの存在を確認します。
    -   存在しない場合は `gh issue create` で新しいIssueを作成します。
    -   `--update` モードの場合、存在すれば `gh issue view` で本文を取得し、`steps.csv` の内容と異なれば `gh issue edit` で更新します。

-   **`steps.csv`**:
    -   Issueの元データとなるCSVファイルです。
    -   `id`: Issueを識別するための一意のID。タイトルに `[id]` として付与され、検索キーとして使われます。
    -   `title`: Issueのタイトル。
    -   `body`: Issueの本文。

## 📜 注意事項

-   スクリプト実行時にネットワーク接続が必要です。
-   大量のIssueを一度に作成・更新する場合、GitHubのAPIレート制限に注意してください。大量のIssueを一度に作成する場合は、`create_issues.sh`内の`while`ループの最後に`sleep 1`という行を追加すると、リクエストの間に1秒間の待機時間が入り、API制限を回避しやすくなります。
-   `steps.csv` はUTF-8で保存してください。
-   `steps.csv` のバックアップを定期的に行うことを推奨します。

## 🆚 よくある質問

-   **Q**: すでに存在するIssueを誤って上書きしたくないのですが。
    **A**: `--update` オプションを使用しなければ、存在するIssueは上書きされません。

-   **Q**: 付与されるラベルを変更したいのですが。
    **A**: スクリプトファイル [`./.github/scripts/create_issues.sh`](./.github/scripts/create_issues.sh) を開き、`LABELS` 変数を変更してください。カンマ区切りで複数指定できます。

-   **Q**: タイトルや本文にカンマが含まれる場合はどうすれば？
    **A**: カンマを含むフィールドは、ダブルクォーテーション `"` で囲んでください。

-   **Q**: スクリプトの実行結果を確認する方法は？
    **A**: スクリプト実行後に、GitHubのリポジトリページでIssueの一覧を確認できます。
-   **Q**: 担当者(Assignee)やマイルストーンも設定できますか？
    **A**: このスクリプトの基本機能には含まれていませんが、`create_issues.sh`内の`gh issue create`コマンドに、`--assignee "ユーザー名"` や `--milestone "マイルストーン名"` といったフラグを追加することで、簡単に拡張できます。詳しくは`gh issue create --help`を参照してください。
