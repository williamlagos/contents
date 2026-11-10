package com.contents.app

import com.contents.app.data.model.ContentItem
import com.contents.app.data.model.MediaAsset
import com.contents.app.data.sample.PreviewData
import kotlinx.serialization.json.Json
import org.junit.Assert.*
import org.junit.Test

class ContentItemTest {
    private val json = Json { ignoreUnknownKeys = true }

    @Test
    fun testContentItemSerialization() {
        val rawJson = """
            {
                "id": 101,
                "slug": "kotlin-compose-starter",
                "title": "Kotlin Compose Starter",
                "content": "Compose content details",
                "summary": "Summary of Kotlin starter",
                "category": "Mobile",
                "tags": ["kotlin", "android"],
                "cover_image": "https://example.com/cover.jpg",
                "status": "published",
                "published_at": "2026-11-12T10:00:00Z",
                "created_at": "2026-11-12T09:00:00Z",
                "updated_at": "2026-11-12T09:30:00Z"
            }
        """.trimIndent()

        val item = json.decodeFromString<ContentItem>(rawJson)
        assertEquals(101, item.id)
        assertEquals("kotlin-compose-starter", item.slug)
        assertEquals("Kotlin Compose Starter", item.title)
        assertEquals("Mobile", item.category)
        assertEquals(2, item.tags.size)
        assertEquals("https://example.com/cover.jpg", item.coverImage)
    }

    @Test
    fun testMediaAssetSerialization() {
        val rawJson = """
            {
                "id": "11111111-2222-3333-4444-555555555555",
                "file_url": "https://cdn.example.com/doc.pdf",
                "file_name": "doc.pdf",
                "mime_type": "application/pdf",
                "file_size": 2048,
                "alt_text": "Sample document",
                "created_at": "2026-11-12T10:00:00Z"
            }
        """.trimIndent()

        val asset = json.decodeFromString<MediaAsset>(rawJson)
        assertEquals("11111111-2222-3333-4444-555555555555", asset.id)
        assertEquals("doc.pdf", asset.fileName)
        assertEquals("application/pdf", asset.mimeType)
        assertEquals(2048L, asset.fileSize)
    }

    @Test
    fun testSampleDataAvailability() {
        assertTrue(PreviewData.sampleContents.isNotEmpty())
        val first = PreviewData.sampleContents.first()
        assertTrue(first.title.isNotEmpty())
        assertTrue(first.slug.isNotEmpty())
    }
}
