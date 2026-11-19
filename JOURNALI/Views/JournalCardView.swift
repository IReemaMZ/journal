
import SwiftUI

struct JournalCardView: View {

    let journal: Journal

    let onBookmark: () -> Void
    let onTap: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            // MARK: - Title and Bookmark

            HStack(alignment: .top) {

                Text(journal.title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(JournalColors.textAccent)
                    .lineLimit(2)

                Spacer()

                Button(action: onBookmark) {

                    Image(
                        systemName: journal.isBookmarked
                            ? "bookmark.fill"
                            : "bookmark"
                    )
                    .font(.system(size: 24))
                    .foregroundStyle(JournalColors.textAccent)
                }
                .buttonStyle(.plain)
            }

            // MARK: - Date

            Text(
                journal.createdAt.formatted(
                    date: .numeric,
                    time: .omitted
                )
            )
            .font(.system(size: 14))
            .foregroundStyle(JournalColors.secondaryText)

            // MARK: - Content

            Text(journal.content)
                .font(.system(size: 18))
                .foregroundStyle(JournalColors.primaryText)
                .lineLimit(5)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(JournalColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .contentShape(RoundedRectangle(cornerRadius: 30))
        .onTapGesture(perform: onTap)
    }
}
