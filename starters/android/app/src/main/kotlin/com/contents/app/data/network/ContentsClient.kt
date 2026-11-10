package com.contents.app.data.network

import com.contents.app.data.model.ContentItem
import com.contents.app.data.sample.PreviewData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

class ContentsClient(
    val baseUrl: String = "http://10.0.2.2:8000/api" // 10.0.2.2 is host loopback for Android emulator
) {
    private val json = Json {
        ignoreUnknownKeys = true
        isLenient = true
        coerceInputValues = true
    }

    suspend fun fetchContents(
        category: String? = null,
        status: String = "published",
        search: String? = null,
        fallbackToSample: Boolean = true
    ): List<ContentItem> = withContext(Dispatchers.IO) {
        val queryBuilder = StringBuilder("?status=${URLEncoder.encode(status, "UTF-8")}")
        if (!category.isNullOrBlank()) {
            queryBuilder.append("&category=${URLEncoder.encode(category, "UTF-8")}")
        }
        if (!search.isNullOrBlank()) {
            queryBuilder.append("&search=${URLEncoder.encode(search, "UTF-8")}")
        }

        try {
            val url = URL("$baseUrl/contents$queryBuilder")
            val connection = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                connectTimeout = 5000
                readTimeout = 5000
                setRequestProperty("Accept", "application/json")
            }

            if (connection.responseCode in 200..299) {
                val responseText = connection.inputStream.bufferedReader().use { it.readText() }
                return@withContext json.decodeFromString<List<ContentItem>>(responseText)
            }
        } catch (_: Exception) {
            // Network failure or timeout; handled below
        }

        if (fallbackToSample) {
            var filtered = PreviewData.sampleContents.filter { it.status == status }
            if (!category.isNullOrBlank()) {
                filtered = filtered.filter { it.category.equals(category, ignoreCase = true) }
            }
            if (!search.isNullOrBlank()) {
                filtered = filtered.filter {
                    it.title.contains(search, ignoreCase = true) ||
                            (it.summary?.contains(search, ignoreCase = true) == true) ||
                            it.content.contains(search, ignoreCase = true)
                }
            }
            return@withContext filtered
        }

        emptyList()
    }

    suspend fun fetchContentBySlug(slug: String, fallbackToSample: Boolean = true): ContentItem? = withContext(Dispatchers.IO) {
        try {
            val encodedSlug = URLEncoder.encode(slug, "UTF-8")
            val url = URL("$baseUrl/contents/slug/$encodedSlug")
            val connection = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                connectTimeout = 5000
                readTimeout = 5000
                setRequestProperty("Accept", "application/json")
            }

            if (connection.responseCode in 200..299) {
                val responseText = connection.inputStream.bufferedReader().use { it.readText() }
                return@withContext json.decodeFromString<ContentItem>(responseText)
            }
        } catch (_: Exception) {
            // Handled below
        }

        if (fallbackToSample) {
            return@withContext PreviewData.sampleContents.firstOrNull { it.slug == slug }
        }

        null
    }
}
