# Go Migrate Example

MySQL データベースのマイグレーションを管理するためのサンプルプロジェクトです。

## 必要条件

- Docker
- Docker Compose
- Make

## セットアップ

1. 環境変数ファイルの準備

```sh
cp .env.example .env
```

2. コンテナの起動

```sh
make up
```

3. コンテナの終了
```sh
make down
```

## マイグレーションコマンド

### 基本的なマイグレーション操作

- マイグレーションファイルの作成

```sh
make create-migration name=create_users
```

- 全てのマイグレーションを実行

```sh
make migrate-up
```

```sh
make migrate-down
```

### 差分マイグレーション

- 1つ先のバージョンにマイグレーション

```sh
make migrate-up-one
```

- 1つ前のバージョンに戻す

```sh
make migrate-down-one
```

- 特定のバージョンまでマイグレーション

```sh
make migrate-goto version=1
```

### 状態確認とトラブルシューティング

- マイグレーションの状態確認

```sh
make migrate-status
```

- マイグレーションのバージョンを強制的に設定（エラー時の復旧用）

```sh
make migrate-force version=1
```

## トラブルシューティング

### Dirty database version エラー

マイグレーションが正常に完了しなかった場合、以下の手順で復旧できます：

1. 現在の状態を確認

```sh
make migrate-status
```

2. 最後に正常だったバージョンに強制的に設定

```sh
make migrate-force version=<last_known_good_version>
```

3. 必要なマイグレーションを再実行

```sh
make migrate-up
```
