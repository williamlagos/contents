# Contents Android Starter

A modern native Android starter for the **Contents** Headless CMS. Built with **Kotlin**, **Jetpack Compose** (Material 3), **Coroutines**, and **Kotlinx Serialization**.

## Features

- **Jetpack Compose & Material 3**: Declarative UI with dynamic category chips, full-text search filtering, and responsive article cards.
- **Async Image Loading**: High-performance image loading and caching using **Coil**.
- **Typed Network Client (`ContentsClient`)**: Coroutines-based HTTP client consuming the Contents Django Ninja API (`/api/contents` and `/api/contents/slug/{slug}`).
- **Offline / Sample Fallback**: Embedded preview data (`PreviewData.sampleContents`) ensures the starter works out-of-the-box offline or when running in the emulator without backend connectivity.
- **Deep Linking Support**: Native support for slug-based lookups.

## Getting Started

### Opening in Android Studio

1. Open Android Studio.
2. Select **Open** and choose the `contents/starters/android` directory.
3. Allow Gradle to sync dependencies.
4. Select an Android Virtual Device (AVD) or connected device and click **Run (Shift + F10)**.

### Running with Gradle Wrapper

Run unit tests:
```bash
./gradlew test
```

Build debug APK:
```bash
./gradlew assembleDebug
```

## Configuration

By default, the client uses `http://10.0.2.2:8000/api` (the standard Android emulator alias for `localhost` on the host machine). For physical devices or custom backend URLs, pass the base URL when instantiating `ContentsClient`:

```kotlin
val client = ContentsClient(baseUrl = "https://cms.yourdomain.com/api")
```
