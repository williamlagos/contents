import Foundation

public struct ContentItem: Identifiable, Codable, Sendable, Hashable {
    public let id: Int
    public let slug: String
    public let title: String
    public let content: String
    public let summary: String?
    public let category: String?
    public let tags: [String]
    public let coverImage: String?
    public let status: String
    public let publishedAt: String?
    public let createdAt: String
    public let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case title
        case content
        case summary
        case category
        case tags
        case coverImage = "cover_image"
        case status
        case publishedAt = "published_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public init(
        id: Int,
        slug: String,
        title: String,
        content: String,
        summary: String? = nil,
        category: String? = nil,
        tags: [String] = [],
        coverImage: String? = nil,
        status: String = "published",
        publishedAt: String? = nil,
        createdAt: String = "",
        updatedAt: String = ""
    ) {
        self.id = id
        self.slug = slug
        self.title = title
        self.content = content
        self.summary = summary
        self.category = category
        self.tags = tags
        self.coverImage = coverImage
        self.status = status
        self.publishedAt = publishedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct MediaAsset: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let fileUrl: String
    public let fileName: String
    public let mimeType: String
    public let fileSize: Int?
    public let altText: String?
    public let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fileUrl = "file_url"
        case fileName = "file_name"
        case mimeType = "mime_type"
        case fileSize = "file_size"
        case altText = "alt_text"
        case createdAt = "created_at"
    }

    public init(
        id: String,
        fileUrl: String,
        fileName: String,
        mimeType: String,
        fileSize: Int? = nil,
        altText: String? = nil,
        createdAt: String = ""
    ) {
        self.id = id
        self.fileUrl = fileUrl
        self.fileName = fileName
        self.mimeType = mimeType
        self.fileSize = fileSize
        self.altText = altText
        self.createdAt = createdAt
    }
}
