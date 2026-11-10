import Foundation

public enum ContentsClientError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case notFound
    case decodingError(String)
    case networkError(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse(let statusCode):
            return "Received invalid response code: \(statusCode)"
        case .notFound:
            return "Requested content could not be found."
        case .decodingError(let detail):
            return "Failed to decode response: \(detail)"
        case .networkError(let message):
            return "Network connection error: \(message)"
        }
    }
}

public actor ContentsClient {
    public let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(baseURL: URL = URL(string: "http://127.0.0.1:8000/api")!) {
        self.baseURL = baseURL
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 8
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
    }

    public func fetchContents(
        category: String? = nil,
        status: String = "published",
        search: String? = nil,
        fallbackToSample: Bool = true
    ) async throws -> [ContentItem] {
        var components = URLComponents(url: baseURL.appendingPathComponent("contents"), resolvingAgainstBaseURL: false)
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "status", value: status)
        ]
        if let category = category, !category.isEmpty {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        if let search = search, !search.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw ContentsClientError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ContentsClientError.invalidResponse(statusCode: 0)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw ContentsClientError.invalidResponse(statusCode: httpResponse.statusCode)
            }
            return try decoder.decode([ContentItem].self, from: data)
        } catch {
            if fallbackToSample {
                var filtered = PreviewData.sampleContents.filter { $0.status == status }
                if let category = category, !category.isEmpty {
                    filtered = filtered.filter { $0.category?.localizedCaseInsensitiveCompare(category) == .orderedSame }
                }
                if let search = search, !search.isEmpty {
                    filtered = filtered.filter {
                        $0.title.localizedCaseInsensitiveContains(search) ||
                        ($0.summary?.localizedCaseInsensitiveContains(search) ?? false) ||
                        $0.content.localizedCaseInsensitiveContains(search)
                    }
                }
                return filtered
            }
            throw ContentsClientError.networkError(error.localizedDescription)
        }
    }

    public func fetchContent(bySlug slug: String, fallbackToSample: Bool = true) async throws -> ContentItem {
        let url = baseURL.appendingPathComponent("contents").appendingPathComponent("slug").appendingPathComponent(slug)

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ContentsClientError.invalidResponse(statusCode: 0)
            }
            if httpResponse.statusCode == 404 {
                throw ContentsClientError.notFound
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw ContentsClientError.invalidResponse(statusCode: httpResponse.statusCode)
            }
            return try decoder.decode(ContentItem.self, from: data)
        } catch {
            if fallbackToSample, let sample = PreviewData.sampleContents.first(where: { $0.slug == slug }) {
                return sample
            }
            throw ContentsClientError.networkError(error.localizedDescription)
        }
    }

    public func fetchContent(byId id: Int, fallbackToSample: Bool = true) async throws -> ContentItem {
        let url = baseURL.appendingPathComponent("contents").appendingPathComponent(String(id))

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ContentsClientError.invalidResponse(statusCode: 0)
            }
            if httpResponse.statusCode == 404 {
                throw ContentsClientError.notFound
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw ContentsClientError.invalidResponse(statusCode: httpResponse.statusCode)
            }
            return try decoder.decode(ContentItem.self, from: data)
        } catch {
            if fallbackToSample, let sample = PreviewData.sampleContents.first(where: { $0.id == id }) {
                return sample
            }
            throw ContentsClientError.networkError(error.localizedDescription)
        }
    }
}
