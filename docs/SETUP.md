# セットアップガイド

## 開発環境のセットアップ

このガイドでは、Newaiрpプロジェクトの開発環境を構築する手順を説明します。

## 必要なツール

### 基本ツール

- **Swift 5.9以上**: [Swift公式サイト](https://swift.org/download/)からダウンロード
- **Git**: バージョン管理システム
- **Terminal/コマンドライン**: macOSのTerminal.appまたは任意のターミナルアプリ

### 推奨ツール

- **Xcode 15.0以上**: App Storeからダウンロード（macOS開発の場合）
- **Visual Studio Code**: 軽量なエディタとして
- **Swift for Visual Studio Code**: Swift開発用拡張機能

## プロジェクトのセットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/rakansens/Newaipp.git
cd Newaipp
```

### 2. 依存関係の確認

```bash
swift package describe
```

### 3. ビルドテスト

```bash
swift build
```

### 4. 実行テスト

```bash
swift run
```

成功すると「Hello, Swift from CI!」が出力されます。

## IDEの設定

### Xcodeでの開発

1. プロジェクトディレクトリで以下を実行：
   ```bash
   swift package generate-xcodeproj
   ```

2. 生成された`.xcodeproj`ファイルを開く

3. スキームが「Newaipp」に設定されていることを確認

### Visual Studio Codeでの開発

1. VS Codeでプロジェクトフォルダを開く

2. Swift拡張機能をインストール：
   - [Swift for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=sswg.swift-lang)

3. `.vscode/settings.json`を作成（オプション）：
   ```json
   {
     "swift.path": "/usr/bin/swift",
     "swift.buildPath": ".build"
   }
   ```

## トラブルシューティング

### よくある問題と解決方法

#### Swift not found

**症状**: `swift: command not found`エラー

**解決方法**:
1. Swiftが正しくインストールされているか確認
2. PATHにSwiftのパスが含まれているか確認：
   ```bash
   echo $PATH
   which swift
   ```

#### Build failed

**症状**: `swift build`が失敗する

**解決方法**:
1. Swift versionを確認：
   ```bash
   swift --version
   ```
2. Package.swiftの`swift-tools-version`と一致しているか確認
3. 依存関係をクリア：
   ```bash
   swift package clean
   swift package resolve
   ```

#### Xcodeプロジェクト生成エラー

**症状**: `swift package generate-xcodeproj`が失敗

**解決方法**:
1. Xcodeのバージョンを確認（15.0以上が必要）
2. Command Line Toolsが正しく設定されているか確認：
   ```bash
   xcode-select -p
   ```

## 次のステップ

環境構築が完了したら、[開発ガイド](DEVELOPMENT.md)を参照して開発フローを確認してください。

## サポート

セットアップで問題が発生した場合は、[Issues](https://github.com/rakansens/Newaipp/issues)でお気軽にお問い合わせください。