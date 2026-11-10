import SwiftUI

@main
struct ContentsApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView()
                .frame(minWidth: 400, minHeight: 600)
        }
    }
}
