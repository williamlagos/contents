package com.contents.app.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ContentItem(
    val id: Int,
    val slug: String,
    val title: String,
    val content: String,
    val summary: String? = null,
    val category: String? = null,
    val tags: List<String> = emptyList(),
    @SerialName("cover_image")
    val coverImage: String? = null,
    val status: String = "published",
    @SerialName("published_at")
    val publishedAt: String? = null,
    @SerialName("created_at")
    val createdAt: String = "",
    @SerialName("updated_at")
    val updatedAt: String = ""
)
