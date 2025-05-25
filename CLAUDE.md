# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Swift Package Manager (SPM) project called "Newaipp" - a basic executable Swift package for app development.

## Architecture

- **Package Type**: Executable Swift package
- **Structure**: Standard SPM layout with `Package.swift` manifest and `Sources/` directory
- **Entry Point**: `Sources/main.swift` contains the executable target

## Development Commands

### Building
```bash
swift build
```

### Running
```bash
swift run
```

### Testing
```bash
swift test
```

### Package Management
```bash
swift package resolve     # Resolve dependencies
swift package clean      # Clean build artifacts
```

## Key Files

- `Package.swift`: SPM manifest defining the package configuration and executable target
- `Sources/main.swift`: Main executable entry point