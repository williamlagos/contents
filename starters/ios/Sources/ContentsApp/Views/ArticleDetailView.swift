import SwiftUI

public struct ArticleDetailView: View {
    public let article: ContentItem

    public init(article: ContentItem) {
        self.article = article
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Cover Image
                if let coverUrl = article.coverImage, let url = URL(string: coverUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 220)
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 220)
                                .overlay(Image(systemName: "photo").font(.largeTitle).foregroundColor(.secondary))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .cornerRadius(12)
                }

                // Category and Date
                HStack {
                    if let category = article.category {
                        Text(category.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.15))
                            .foregroundColor(.accentColor)
                            .cornerRadius(8)
                    }

                    Spacer()

                    if let publishedAt = article.publishedAt {
                        Text(formatDate(publishedAt))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // Title
                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                // Summary
                if let summary = article.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }

                Divider()

                // Content body
                Text(article.content)
                    .font(.body)
                    .lineSpacing(6)
                    .foregroundColor(.primary)

                // Tags
                if !article.tags.isEmpty {
                    Divider()
                        .padding(.top, 8)

                    Text("Tags")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    FlowLayout(spacing: 8) {
                        ForEach(article.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(16)
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle(article.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func formatDate(_ isoString: String) -> String {
        return isoString.prefix(10).description
    }
}

// Simple horizontal wrapping layout for tags
public struct FlowLayout: Layout {
    public var spacing: CGFloat = 8

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxHeightInRow: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                x = 0
                y += maxHeightInRow + spacing
                maxHeightInRow = 0
            }
            maxHeightInRow = max(maxHeightInRow, size.height)
            x += size.width + spacing
        }
        height = y + maxHeightInRow
        return CGSize(width: width, height: height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var maxHeightInRow: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX
                y += maxHeightInRow + spacing
                maxHeightInRow = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            maxHeightInRow = max(maxHeightInRow, size.height)
            x += size.width + spacing
        }
    }
}
