# 開発ガイド

## 開発フロー

Newaiрpプロジェクトの開発に参加する際の手順とガイドラインです。

## ブランチ戦略

### ブランチの種類

- **main**: 本番環境用の安定版ブランch
- **develop**: 開発版ブランch（使用する場合）
- **feature/***: 新機能開発用ブランch
- **bugfix/***: バグ修正用ブランch
- **hotfix/***: 緊急修正用ブランch

### ブランチ命名規則

```
feature/機能名-簡潔な説明
bugfix/issue番号-バグの概要
hotfix/緊急度-修正内容
```

例:
- `feature/user-auth-system`
- `bugfix/issue-123-memory-leak`
- `hotfix/critical-security-patch`

## コーディング規約

### Swift コーディングスタイル

#### 命名規則

```swift
// クラス・構造体・プロトコル: PascalCase
class UserManager { }
struct APIResponse { }
protocol DataSource { }

// 変数・関数: camelCase
var userName: String
func calculateTotal() -> Double

// 定数: camelCase（定数の場合はkプレフィックスも可）
let maxRetryCount = 3
let kDefaultTimeout = 30.0

// 列挙型: PascalCase（ケースはcamelCase）
enum NetworkState {
    case connected
    case disconnected
    case reconnecting
}
```

#### インデント・フォーマット

- インデント: スペース4個
- 行の最大長: 120文字
- 関数の引数が複数行にわたる場合の整列

```swift
func complexFunction(
    firstParameter: String,
    secondParameter: Int,
    thirdParameter: Bool
) -> String {
    // 実装
}
```

#### コメント

```swift
// MARK: - セクションの区切り
// TODO: 実装予定の機能
// FIXME: 修正が必要な箇所
// NOTE: 重要な注意事項

/// ドキュメントコメント（関数・クラスの説明）
/// - Parameter name: パラメータの説明
/// - Returns: 戻り値の説明
func documentedFunction(name: String) -> String {
    return "Hello, \(name)"
}
```

## 開発ワークフロー

### 1. 新機能の開発

```bash
# 最新のmainブランチを取得
git checkout main
git pull origin main

# フィーチャーブランチを作成
git checkout -b feature/new-awesome-feature

# 開発・テスト・コミット
# ...

# プッシュしてプルリクエスト作成
git push origin feature/new-awesome-feature
```

### 2. コミットメッセージ規約

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

#### Type（必須）

- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメントのみ変更
- `style`: フォーマット変更（コード動作に影響なし）
- `refactor`: リファクタリング
- `test`: テスト追加・修正
- `chore`: ビルドプロセス・補助ツール変更

#### 例

```
feat(auth): ユーザー認証システムを追加

- OAuth 2.0サポート
- JWT トークン管理
- ログイン/ログアウト機能

Closes #123
```

### 3. プルリクエスト

#### PRテンプレート

```markdown
## 概要
変更内容の簡潔な説明

## 変更内容
- [ ] 新機能の追加
- [ ] バグの修正
- [ ] リファクタリング
- [ ] ドキュメント更新

## テスト
- [ ] 単体テスト追加/更新
- [ ] 統合テスト確認
- [ ] 手動テスト実施

## チェックリスト
- [ ] コーディング規約に準拠
- [ ] ドキュメント更新済み
- [ ] テストが通過
- [ ] レビューア指定
```

## テスト戦略

### テストの種類

1. **単体テスト（Unit Tests）**
   ```bash
   swift test
   ```

2. **統合テスト（Integration Tests）**
   - API連携テスト
   - データベース連携テスト

3. **UI テスト（UI Tests）**
   - Xcodeを使用したUIテスト

### テストの書き方

```swift
import XCTest
@testable import Newaipp

final class NewaiрpTests: XCTestCase {
    
    func testExample() throws {
        // テストコード
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func testPerformanceExample() throws {
        measure {
            // パフォーマンステストコード
        }
    }
}
```

## デバッグとロギング

### ログレベル

```swift
// 開発時のみ
#if DEBUG
print("Debug: \(message)")
#endif

// プロダクション対応ログ
os_log("Info: %@", log: .default, type: .info, message)
```

### デバッグツール

- **Xcode Debugger**: ブレークポイント・変数監視
- **Instruments**: パフォーマンス分析
- **Console.app**: システムログ確認

## リリースプロセス

### バージョニング

セマンティックバージョニング（Semantic Versioning）を使用：
- **MAJOR.MINOR.PATCH** (例: 1.2.3)
- MAJOR: 非互換な変更
- MINOR: 後方互換性のある新機能
- PATCH: 後方互換性のあるバグ修正

### リリース手順

1. リリースブランチ作成
2. バージョン番号更新
3. CHANGELOG.md更新
4. テスト実行・検証
5. main ブランchにマージ
6. タグ作成・リリース

## 継続的インテグレーション

### GitHub Actions

- プルリクエスト時の自動テスト
- コードフォーマットチェック
- 静的解析

## パフォーマンス考慮事項

### メモリ管理

- ARC（Automatic Reference Counting）の理解
- 循環参照の回避
- `weak`・`unowned`の適切な使用

### 実行効率

- 不要な処理の削減
- 非同期処理の活用
- キャッシュ戦略

## セキュリティ

### 基本原則

- 入力値の検証
- 機密データの適切な取り扱い
- 通信の暗号化
- 認証・認可の実装

## 次のステップ

開発環境の準備ができたら、[API文書](API.md)を参照して具体的な実装を始めてください。

## 質問・サポート

開発に関する質問や提案は、[Issues](https://github.com/rakansens/Newaipp/issues)または[Discussions](https://github.com/rakansens/Newaipp/discussions)でお気軽にお聞かせください。