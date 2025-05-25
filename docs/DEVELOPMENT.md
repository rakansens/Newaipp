# 開発ガイド

このドキュメントでは、Newaippプロジェクトでの開発方法について説明します。

## プロジェクト構造の理解

### 現在の構造

```
Newaipp/
├── Package.swift          # パッケージ設定
├── Sources/
│   └── main.swift        # アプリケーションエントリーポイント
└── docs/                 # ドキュメント
```

### ファイルの説明

#### Package.swift
Swift Package Managerの設定ファイルです。プロジェクトの名前、ターゲット、依存関係を定義します。

#### Sources/main.swift
アプリケーションのメインエントリーポイントです。現在は簡単なHello Worldメッセージを表示しています。

## 開発ワークフロー

### 1. ブランチ戦略

推奨されるブランチ戦略：

```
main                    # 本番対応可能なコード
├── develop            # 開発統合ブランチ
├── feature/新機能名    # 機能開発ブランチ
├── bugfix/バグ修正名   # バグ修正ブランチ
└── hotfix/緊急修正名   # 緊急修正ブランチ
```

### 2. 開発サイクル

1. **機能ブランチの作成**
   ```bash
   git checkout -b feature/新機能名
   ```

2. **コード作成・編集**
   ```bash
   # コードを編集
   swift build  # ビルド確認
   swift run    # 動作確認
   ```

3. **テスト実行**
   ```bash
   swift test  # テストが実装されている場合
   ```

4. **コミット**
   ```bash
   git add .
   git commit -m "feat: 新機能の説明"
   ```

5. **プッシュとプルリクエスト**
   ```bash
   git push origin feature/新機能名
   # GitHubでプルリクエストを作成
   ```

## コーディング規約

### Swift言語規約

#### 1. 命名規則

- **クラス、構造体、列挙型**: PascalCase
  ```swift
  class UserManager { }
  struct AppConfig { }
  enum NetworkError { }
  ```

- **変数、関数、プロパティ**: camelCase
  ```swift
  let userName = "John"
  func fetchUserData() { }
  var isLoggedIn = false
  ```

- **定数**: camelCase（グローバル定数はUppercase可）
  ```swift
  let maxRetryCount = 3
  let API_BASE_URL = "https://api.example.com"
  ```

#### 2. インデント

- スペース4つを使用
- タブ文字は使用しない

#### 3. 関数の書き方

```swift
func processUserData(
    userID: String,
    includeProfile: Bool = true,
    completion: @escaping (Result<User, Error>) -> Void
) {
    // 実装
}
```

#### 4. コメント

```swift
// MARK: - Public Methods

/// ユーザーデータを取得します
/// - Parameter userID: ユーザーID
/// - Returns: ユーザー情報のResult
func fetchUser(userID: String) -> Result<User, Error> {
    // 実装
}
```

## 新機能の追加

### 1. 基本的なファイル追加

新しいSwiftファイルを追加する場合：

1. `Sources/`ディレクトリに新しい`.swift`ファイルを作成
2. 必要に応じて`Package.swift`を更新
3. 適切なアクセス制御レベルを設定

### 2. 依存関係の追加

外部ライブラリを追加する場合、`Package.swift`を編集：

```swift
let package = Package(
    name: "Newaipp",
    dependencies: [
        .package(url: "https://github.com/example/SomeLibrary.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "Newaipp",
            dependencies: ["SomeLibrary"],
            path: "Sources"
        )
    ]
)
```

## デバッグとテスト

### 1. デバッグ

- Xcodeを使用する場合：ブレークポイントと`po`コマンドを活用
- コマンドラインの場合：`print()`文や`dump()`関数を使用

### 2. テストの追加

テストターゲットを追加する場合：

```swift
// Package.swiftにテストターゲットを追加
.testTarget(
    name: "NewaippTests",
    dependencies: ["Newaipp"]
)
```

## パフォーマンス最適化

### 1. ビルド最適化

- リリースビルド：`swift build -c release`
- デバッグ情報付きリリース：`swift build -c release -Xswiftc -g`

### 2. コード最適化

- 不要なインポートを削除
- 適切なデータ構造を選択
- メモリ効率を考慮した実装

## CI/CD

プロジェクトでGitHub Actionsが設定されている場合、以下の点に注意：

1. **ビルドの確認**: プルリクエスト時に自動ビルドが実行される
2. **テストの実行**: テストが自動で実行される
3. **コード品質**: 静的解析ツールが実行される場合がある

## 次のステップ

- [API文書](API.md)でプロジェクトのAPIについて学習
- セットアップが完了していない場合は[セットアップガイド](SETUP.md)を参照