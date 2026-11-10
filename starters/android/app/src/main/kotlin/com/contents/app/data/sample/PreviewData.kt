package com.contents.app.data.sample

import com.contents.app.data.model.ContentItem

object PreviewData {
    val sampleContents = listOf(
        ContentItem(
            id = 1,
            slug = "getting-started-with-contents",
            title = "Getting Started with Contents CMS",
            content = """
                Contents is a headless Content Management System built with Django Ninja and modern client SDKs.
                
                Key highlights:
                • Blazing fast OpenAPI-backed REST API endpoints
                • Native starters for Web (React), iOS (SwiftUI), and Android (Jetpack Compose)
                • Flexible category taxonomies and tag filtering
                • Integrated media asset management with zero-config uploads
            """.trimIndent(),
            summary = "Learn how Contents CMS powers modern cross-platform content delivery across Web, iOS, and Android.",
            category = "Guides",
            tags = listOf("headless-cms", "architecture", "starter"),
            coverImage = "https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&w=1200&q=80",
            status = "published",
            publishedAt = "2026-11-06T12:00:00Z",
            createdAt = "2026-11-06T12:00:00Z",
            updatedAt = "2026-11-06T12:00:00Z"
        ),
        ContentItem(
            id = 2,
            slug = "native-mobile-starters",
            title = "Building Native Mobile Clients with SwiftUI and Compose",
            content = """
                Consuming your headless API from native mobile applications provides unmatched performance and native UX.
                
                Our iOS starter leverages SwiftUI with async/await and NavigationStack, while the Android starter uses Kotlin with Jetpack Compose.
                
                Both support automatic offline fallback, category filtering, and direct slug-based deep linking.
            """.trimIndent(),
            summary = "Explore the SwiftUI and Jetpack Compose mobile starter templates included with Contents CMS.",
            category = "Mobile",
            tags = listOf("swiftui", "compose", "mobile", "ios", "android"),
            coverImage = "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&w=1200&q=80",
            status = "published",
            publishedAt = "2026-11-08T10:00:00Z",
            createdAt = "2026-11-08T10:00:00Z",
            updatedAt = "2026-11-08T10:00:00Z"
        ),
        ContentItem(
            id = 3,
            slug = "media-asset-pipeline",
            title = "Unified Media Management for Headless Content",
            content = """
                Managing images, audio, and documents across multiple channels is simplified with our new Media Asset pipeline.
                
                Upload media directly via multipart form POST or register cloud storage URLs. Every asset gets UUID tracking, MIME-type inspection, and metadata preservation.
            """.trimIndent(),
            summary = "How the Contents media asset router streamlines asset delivery across web and native mobile apps.",
            category = "Architecture",
            tags = listOf("media", "storage", "django-ninja"),
            coverImage = "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=1200&q=80",
            status = "published",
            publishedAt = "2026-11-10T09:30:00Z",
            createdAt = "2026-11-10T09:30:00Z",
            updatedAt = "2026-11-10T09:30:00Z"
        )
    )
}
