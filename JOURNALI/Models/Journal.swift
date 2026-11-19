
import Foundation
import SwiftData

@Model
final class Journal {

    @Attribute(.unique)
    var id: UUID

    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var isBookmarked: Bool

    init(
        title: String,
        content: String,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        isBookmarked: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isBookmarked = isBookmarked
    }
}
