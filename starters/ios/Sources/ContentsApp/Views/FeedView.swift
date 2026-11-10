import SwiftUI

@MainActor
public final class FeedViewModel: ObservableObject {
    @Published public var articles: [ContentItem] = []
    @Published public var selectedCategory: String = "All"
    @Published public var searchText: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    public let categories = ["All", "Guides", "Mobile", "Architecture"]
    private let client: ContentsClient

    public init(client: ContentsClient = ContentsClient()) {
        self.client = client
    }

    public func loadArticles() async {
        isLoading = true
        errorMessage = nil
        do {
            let cat = selectedCategory == "All" ? nil : selectedCategory
            let items = try await client.fetchContents(
                category: cat,
                status: "published",
                search: searchText.isEmpty ? nil : searchText,
                fallbackToSample: true
            )
            self.articles = items
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

public struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.categories, id: \.self) { cat in
                            Button {
                                viewModel.selectedCategory = cat
                                Task {
                                    await viewModel.loadArticles()
                                }
                            } label: {
                                Text(cat)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == cat ? Color.accentColor : Color.secondary.opacity(0.12))
                                    .foregroundColor(viewModel.selectedCategory == cat ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }

                // Article List
                List {
                    ForEach(viewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            ArticleRow(article: article)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.loadArticles()
                }
                .overlay {
                    if viewModel.isLoading && viewModel.articles.isEmpty {
                        ProgressView("Loading articles…")
                    } else if viewModel.articles.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("No articles found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Contents")
            .searchable(text: $viewModel.searchText, prompt: "Search articles...")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.loadArticles()
                }
            }
            .task {
                if viewModel.articles.isEmpty {
                    await viewModel.loadArticles()
                }
            }
        }
    }
}

public struct ArticleRow: View {
    public let article: ContentItem

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let coverUrl = article.coverImage, let url = URL(string: coverUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                            .cornerRadius(10)
                    case .empty:
                        Rectangle()
                            .fill(Color.secondary.opacity(0.1))
                            .frame(height: 160)
                            .overlay(ProgressView())
                            .cornerRadius(10)
                    default:
                        EmptyView()
                    }
                }
            }

            HStack {
                if let category = article.category {
                    Text(category.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }
                Spacer()
                if let publishedAt = article.publishedAt {
                    Text(publishedAt.prefix(10))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Text(article.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)

            if let summary = article.summary, !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(14)
        .background(Color.secondary.opacity(0.06))
        .cornerRadius(12)
    }
}
