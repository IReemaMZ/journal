
import Foundation
import SwiftData
import Combine

// MARK: - Journal ViewModel

@MainActor
final class JournalViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var journals: [Journal] = []

    // MARK: - Properties

    private let modelContext: ModelContext

    // MARK: - Initializer

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchJournals()
    }

    // MARK: - Fetch Journals

    func fetchJournals() {

        let descriptor = FetchDescriptor<Journal>(
            sortBy: [
                SortDescriptor(
                    \Journal.createdAt,
                    order: .reverse
                )
            ]
        )

        do {
            journals = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching journals: \(error)")
        }
    }

    // MARK: - Add Journal

    func addJournal(title: String, content: String) {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty else { return }

        let journal = Journal(
            title: cleanTitle,
            content: content
        )

        modelContext.insert(journal)
        saveChanges()
    }

    // MARK: - Update Journal

    func updateJournal(
        _ journal: Journal,
        title: String,
        content: String
    ) {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty else { return }

        journal.title = cleanTitle
        journal.content = content
        journal.updatedAt = .now

        saveChanges()
    }

    // MARK: - Delete Journal

    func deleteJournal(_ journal: Journal) {
        modelContext.delete(journal)
        saveChanges()
    }

    // MARK: - Toggle Bookmark

    func toggleBookmark(_ journal: Journal) {
        journal.isBookmarked.toggle()
        saveChanges()
    }

    // MARK: - Save Changes

    private func saveChanges() {

        do {
            try modelContext.save()
            fetchJournals()
        } catch {
            print("Error saving journals: \(error)")
        }
    }
}
