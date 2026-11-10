# Contents iOS & macOS Starter

A modern, native SwiftUI mobile starter for the **Contents** Headless CMS. Built with Swift 6, structured concurrency (`async/await`), NavigationStack, and type-safe model decoding.

## Features

- **SwiftUI & Modern Concurrency**: Native UI with pull-to-refresh (`.refreshable`), async image thumbnail loading (`AsyncImage`), category chips, and tag wrapping layouts.
- **Typed SDK (`ContentsClient`)**: Actor-isolated network client communicating with the Contents Django Ninja API (`/api/contents` and `/api/contents/slug/{slug}`).
- **Offline / Preview Fallback**: Seamless fallback to bundled sample data (`PreviewData.sampleContents`) when developing offline or previewing in Xcode.
- **Cross-Platform**: Supports iOS 16+ and macOS 13+ via Swift Package Manager or Xcode.

## Getting Started

### Using Swift Package Manager CLI

Run tests:
```bash
swift test
```

Build executable:
```bash
swift build
```

Run application:
```bash
swift run ContentsApp
```

### Opening in Xcode

1. Open Xcode and select **File > Open**.
2. Navigate to `contents/starters/ios` and select the folder (or open `Package.swift`).
3. Select your target device (iPhone Simulator, iPad, or Mac Designed for iPad / macOS) and press **Cmd + R**.

## Configuration

By default, `ContentsClient` points to `http://127.0.0.1:8000/api`. To point to a custom host or production domain, initialize `ContentsClient` with your URL:

```swift
let client = ContentsClient(baseURL: URL(string: "https://cms.yourdomain.com/api")!)
```
