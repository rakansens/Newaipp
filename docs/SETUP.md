# セットアップガイド

このドキュメントでは、Newaippプロジェクトの開発環境をセットアップする方法について説明します。

## 必要なツール

### 1. Swift

- **バージョン**: Swift 5.9以上
- **インストール方法**:
  - **macOS**: Xcodeをインストールするか、Swift.orgから単体でダウンロード
  - **Linux**: Swift.orgからLinux用バイナリをダウンロード
  - **Windows**: Swift.orgからWindows用バイナリをダウンロード

#### Swiftのバージョン確認
```bash
swift --version
```

### 2. Xcode（macOSの場合）

- **バージョン**: Xcode 15.0以上
- **インストール方法**: App StoreまたはApple Developer Portalからダウンロード

#### Xcodeのバージョン確認
```bash
xcodebuild -version
```

## プロジェクトのセットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/rakansens/Newaipp.git
cd Newaipp
```

### 2. 依存関係の解決

```bash
swift package resolve
```

### 3. プロジェクトのビルド

```bash
swift build
```

### 4. テスト実行（テストが追加された場合）

```bash
swift test
```

## IDEの設定

### Xcode

XcodeでSwift Package Managerプロジェクトを開く：

```bash
open Package.swift
```

または、Xcodeから「File > Open」でPackage.swiftを選択します。

### Visual Studio Code

推奨拡張機能：
- Swift for Visual Studio Code
- Swift Language Support

### その他のエディタ

以下のエディタでもSwift開発をサポートしています：
- AppCode
- Sublime Text（Swift Bundle使用）
- Vim/Neovim（SourceKit-LSP使用）

## 問題解決

### よくある問題

#### 1. Swiftコマンドが見つからない

**解決方法**:
- PATHにSwiftのインストール場所が含まれているか確認
- macOSの場合、Command Line Toolsをインストール: `xcode-select --install`

#### 2. ビルドエラー

**解決方法**:
- 依存関係をクリーンアップ: `swift package clean`
- 依存関係を再解決: `swift package resolve`

#### 3. Xcodeでプロジェクトが正しく読み込まれない

**解決方法**:
- Xcodeを終了し、Package.swiftを直接開く
- Derived Dataをクリア（Xcode > Preferences > Locations > Derived Data）

## 次のステップ

セットアップが完了したら、[開発ガイド](DEVELOPMENT.md)を参照して開発を開始してください。