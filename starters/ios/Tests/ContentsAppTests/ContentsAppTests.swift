import XCTest
@testable import ContentsApp

final class ContentsAppTests: XCTestCase {
    func testContentItemDecoding() throws {
        let json = """
        {
            "id": 42,
            "slug": "test-slug",
            "title": "Test Title",
            "content": "Test body content",
            "summary": "Short summary",
            "category": "Tech",
            "tags": ["swift", "testing"],
            "cover_image": "https://example.com/cover.png",
            "status": "published",
            "published_at": "2026-11-12T10:00:00Z",
            "created_at": "2026-11-12T09:00:00Z",
            "updated_at": "2026-11-12T09:30:00Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let item = try decoder.decode(ContentItem.self, from: json)

        XCTAssertEqual(item.id, 42)
        XCTAssertEqual(item.slug, "test-slug")
        XCTAssertEqual(item.title, "Test Title")
        XCTAssertEqual(item.category, "Tech")
        XCTAssertEqual(item.tags, ["swift", "testing"])
        XCTAssertEqual(item.coverImage, "https://example.com/cover.png")
        XCTAssertEqual(item.status, "published")
    }

    func testMediaAssetDecoding() throws {
        let json = """
        {
            "id": "e7b0c36b-67a6-4bfe-9892-0b298492067c",
            "file_url": "https://cdn.example.com/image.jpg",
            "file_name": "image.jpg",
            "mime_type": "image/jpeg",
            "file_size": 1048576,
            "alt_text": "Sample hero image",
            "created_at": "2026-11-12T10:00:00Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let asset = try decoder.decode(MediaAsset.self, from: json)

        XCTAssertEqual(asset.id, "e7b0c36b-67a6-4bfe-9892-0b298492067c")
        XCTAssertEqual(asset.fileName, "image.jpg")
        XCTAssertEqual(asset.mimeType, "image/jpeg")
        XCTAssertEqual(asset.fileSize, 1048576)
        XCTAssertEqual(asset.altText, "Sample hero image")
    }

    func testPreviewDataAvailable() {
        XCTAssertFalse(PreviewData.sampleContents.isEmpty)
        let first = PreviewData.sampleContents[0]
        XCTAssertFalse(first.title.isEmpty)
        XCTAssertFalse(first.slug.isEmpty)
    }

    func testContentsClientFallback() async throws {
        let client = ContentsClient(baseURL: URL(string: "http://127.0.0.1:9999/unreachable-api")!)
        let items = try await client.fetchContents(fallbackToSample: true)
        XCTAssertFalse(items.isEmpty)
        XCTAssertEqual(items.count, PreviewData.sampleContents.count)
    }
}
