# My Python Project Template

モダンな開発手法を取り入れた、個人用のPythonプロジェクトテンプレートです。過剰な機能を避け、シンプルさと堅牢な開発体験の両立を目指しています。

## ✨ 概要 (Overview)

このテンプレートは、新しいPythonアプリケーションを始める際の面倒な初期設定をなくし、すぐにビジネスロジックの実装に集中できるように設計されています。Poetryによる依存関係管理、Ruffによる静的解析とフォーマット、pytestによるテスト、GitHub ActionsによるCIなど、現在のベストプラクティスを採用しています。

## 🛠️ 技術スタック & 方針 (Tech Stack & Philosophy)

このテンプレートは、以下のツールと方針を標準としています。

  - **パッケージ管理**: [**Poetry (2.x系)**](https://python-poetry.org/)
      - `pyproject.toml`による一元的な依存関係・プロジェクト管理。
  - **Pythonバージョン**: **3.12以降**
      - 最新の言語機能を活用し、古いバージョンへの後方互換性を考慮しません。
  - **フォルダ構成**: **`src`レイアウト**
      - ソースコードと設定ファイルを明確に分離し、インポート問題を回避します。
  - **コード品質管理**: [**Ruff**](https://docs.astral.sh/ruff/) + [**pre-commit**](https://pre-commit.com/)
      - `git commit`時に、Ruffによる高速なリンティングとフォーマットを自動で実行します。
  - **テスト**: [**pytest**](https://docs.pytest.org/) + [**pytest-cov**](https://pytest-cov.readthedocs.io/)
      - シンプルかつ高機能なテストフレームワークで、テストカバレッジの計測も標準で行います。
  - **自動化 (CI)**: [**GitHub Actions**](https://github.com/features/actions)
      - `git push`時に、リントとテストを自動で実行し、コードの品質を常に保ちます。
  - **その他**:
      - `Dockerfile`によるコンテナ化に対応。
      - VS Codeでの開発体験を最適化する設定 (`.vscode/settings.json`) を同梱。

## 🚀 使い方 (Getting Started)

### 前提条件

  - [Git](https://git-scm.com/)
  - [GitHub CLI](https://cli.github.com/) (`gh`)
  - [pyenv](https://github.com/pyenv/pyenv) (推奨)
  - Python 3.12以降
  - [Poetry](https://python-poetry.org/)

### セットアップ手順

1.  **このリポジトリから新しいリポジトリを作成**
    このGitHubリポジトリのページで、緑色の **「Use this template」** ボタンを押し、「Create a new repository」を選択して、あなたの新しいプロジェクト用のリポジトリを作成します。

2.  **ローカルにクローン**

    ```bash
    gh repo clone YOUR_USERNAME/YOUR_NEW_REPO_NAME
    cd YOUR_NEW_REPO_NAME
    ```

3.  **Pythonバージョンの設定（推奨）**
    プロジェクトで使うPythonのバージョンを固定します。

    ```bash
    pyenv local 3.12.4
    ```

4.  **依存関係のインストール**
    Poetryを使って、開発ツールを含む全ての依存関係をインストールします。

    ```bash
    poetry install
    ```

5.  **pre-commitフックの有効化**
    Gitのコミット時に品質チェックが自動で走るように設定します。

    ```bash
    poetry run pre-commit install
    ```

6.  **環境変数の設定**
    `.env.example`をコピーして`.env`ファイルを作成し、必要な値を設定します。

    ```bash
    cp .env.example .env
    # .env ファイルをエディタで開いて編集する
    ```

これで、開発を始める準備が整いました！

## コマンド一覧 (Available Commands)

頻繁に使うコマンドは`Makefile`にショートカットとして定義されています。

  - **依存関係のインストール**:
    ```bash
    make install
    # poetry install を実行します
    ```
  - **テストの実行**:
    ```bash
    make test
    # poetry run pytest を実行します
    ```
  - **リント & フォーマットチェック**:
    ```bash
    make lint
    # poetry run pre-commit run --all-files を実行します
    ```
  - **アプリケーションの起動（例）**:
    ```bash
    make run
    # uvicorn src.my_project_name.main:app --reload などを実行します（要実装）
    ```
