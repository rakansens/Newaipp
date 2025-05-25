# API ドキュメント

このドキュメントでは、Newaippプロジェクトの現在のAPIと将来的に追加予定のAPIについて説明します。

## 現在のAPI

### メインエントリーポイント

#### main.swift

**ファイル**: `Sources/main.swift`

**説明**: アプリケーションのメインエントリーポイントです。

**現在の実装**:
```swift
print("Hello, Swift from CI!")
```

**機能**:
- アプリケーションの開始点
- 基本的なメッセージ出力

**戻り値**: なし（Void）

**例外**: なし

## 将来の拡張API設計

### 1. アプリケーション管理

#### AppManager クラス

```swift
class AppManager {
    /// アプリケーションを初期化します
    static func initialize() -> AppManager
    
    /// アプリケーションを開始します
    func start() throws
    
    /// アプリケーションを停止します
    func stop() throws
    
    /// アプリケーションの状態を取得します
    var status: AppStatus { get }
}
```

#### AppStatus 列挙型

```swift
enum AppStatus {
    case idle        // 待機中
    case running     // 実行中
    case stopped     // 停止
    case error(Error) // エラー状態
}
```

### 2. 設定管理

#### ConfigurationManager クラス

```swift
class ConfigurationManager {
    /// 設定を読み込みます
    /// - Parameter path: 設定ファイルのパス
    /// - Returns: 読み込んだ設定
    /// - Throws: ファイル読み込みエラー
    static func loadConfiguration(from path: String) throws -> Configuration
    
    /// 設定を保存します
    /// - Parameters:
    ///   - configuration: 保存する設定
    ///   - path: 保存先のパス
    /// - Throws: ファイル書き込みエラー
    static func saveConfiguration(_ configuration: Configuration, to path: String) throws
}
```

#### Configuration 構造体

```swift
struct Configuration: Codable {
    let appName: String
    let version: String
    let debugMode: Bool
    let logLevel: LogLevel
}
```

### 3. ログ管理

#### Logger クラス

```swift
class Logger {
    /// ログレベルを設定します
    static var logLevel: LogLevel
    
    /// 情報ログを出力します
    /// - Parameter message: ログメッセージ
    static func info(_ message: String)
    
    /// 警告ログを出力します
    /// - Parameter message: ログメッセージ
    static func warning(_ message: String)
    
    /// エラーログを出力します
    /// - Parameter message: ログメッセージ
    static func error(_ message: String)
    
    /// デバッグログを出力します
    /// - Parameter message: ログメッセージ
    static func debug(_ message: String)
}
```

#### LogLevel 列挙型

```swift
enum LogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    
    var priority: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        }
    }
}
```

### 4. エラーハンドリング

#### AppError 列挙型

```swift
enum AppError: Error, LocalizedError {
    case configurationError(String)
    case initializationError(String)
    case runtimeError(String)
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .configurationError(let message):
            return "設定エラー: \(message)"
        case .initializationError(let message):
            return "初期化エラー: \(message)"
        case .runtimeError(let message):
            return "実行時エラー: \(message)"
        case .networkError(let message):
            return "ネットワークエラー: \(message)"
        }
    }
}
```

## API使用例

### 基本的な使用方法

```swift
import Foundation

// アプリケーション初期化
let appManager = AppManager.initialize()

do {
    // 設定読み込み
    let config = try ConfigurationManager.loadConfiguration(from: "config.json")
    
    // ログレベル設定
    Logger.logLevel = config.logLevel
    
    // アプリケーション開始
    try appManager.start()
    
    Logger.info("アプリケーションが正常に開始されました")
    
} catch let error as AppError {
    Logger.error("アプリケーションエラー: \(error.localizedDescription)")
} catch {
    Logger.error("予期しないエラー: \(error.localizedDescription)")
}
```

### 設定ファイルの例

```json
{
    "appName": "Newaipp",
    "version": "1.0.0",
    "debugMode": true,
    "logLevel": "INFO"
}
```

## APIの拡張方針

### 1. 互換性の維持

- 既存のAPIを変更する場合は、deprecation警告を追加
- セマンティックバージョニングに従う
- 破壊的変更は Major バージョンアップ時のみ

### 2. ドキュメント更新

- 新しいAPIを追加した際は、このドキュメントを更新
- コード内のドキュメントコメントも同時に更新
- 使用例を追加

### 3. テストの追加

- 新しいAPIには対応するテストを追加
- 既存APIの変更時はテストも更新
- エラーケースのテストも忘れずに実装

## パフォーマンス考慮事項

### 1. メモリ使用量

- 大きなデータ構造は遅延初期化を検討
- 不要なオブジェクトは適切に解放

### 2. CPU使用率

- 重い処理は非同期で実行
- 適切なキャッシュ戦略を実装

### 3. I/O操作

- ファイル操作は非同期API使用を推奨
- ネットワーク操作にはタイムアウトを設定

## 関連リンク

- [開発ガイド](DEVELOPMENT.md)
- [セットアップガイド](SETUP.md)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)