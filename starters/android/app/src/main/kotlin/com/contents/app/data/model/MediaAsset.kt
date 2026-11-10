package com.contents.app.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class MediaAsset(
    val id: String,
    @SerialName("file_url")
    val fileUrl: String,
    @SerialName("file_name")
    val fileName: String,
    @SerialName("mime_type")
    val mimeType: String,
    @SerialName("file_size")
    val fileSize: Long? = null,
    @SerialName("alt_text")
    val altText: String? = null,
    @SerialName("created_at")
    val createdAt: String = ""
)
