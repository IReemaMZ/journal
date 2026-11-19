
import SwiftUI

struct ContentView: View {

    // MARK: - ViewModels

    @ObservedObject var viewModel: JournalViewModel

    @StateObject private var appViewModel = AppViewModel()

    // MARK: - States

    @State private var searchText = ""
    @State private var bookmarkedOnly = false
    @State private var sortByBookmark = false
    @State private var showingEditor = false
    @State private var selectedJournal: Journal?
    @State private var showingDeleteAlert = false
    @State private var journalToDelete: Journal?

    // MARK: - Filtered Journals

    private var filteredJournals: [Journal] {

        var results = viewModel.journals

        // Filter by bookmark

        if bookmarkedOnly {
            results = results.filter {
                $0.isBookmarked
            }
        }

        // Search journals

        if !searchText.isEmpty {
            results = results.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Sort journals

        if sortByBookmark {
            results.sort {
                if $0.isBookmarked != $1.isBookmarked {
                    return $0.isBookmarked && !$1.isBookmarked
                }

                return $0.createdAt > $1.createdAt
            }
        } else {
            results.sort {
                $0.createdAt > $1.createdAt
            }
        }

        return results
    }

    // MARK: - Body

    var body: some View {

        Group {

            if appViewModel.isShowingSplash {

                SplashView()
                    .task {
                        await appViewModel.finishSplashAfterDelay()
                    }

            } else {

                mainJournalView
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Main Journal View

    private var mainJournalView: some View {

        NavigationStack {

            VStack(spacing: 0) {

                // Header

                headerView

                // Journal Content

                if filteredJournals.isEmpty {

                    if viewModel.journals.isEmpty &&
                        searchText.isEmpty &&
                        !bookmarkedOnly {

                        EmptyStateView()

                    } else {

                        noResultsView
                    }

                } else {

                    journalList
                }
            }
            .background(JournalColors.background)
            .safeAreaInset(edge: .bottom) {
                searchBar
            }
            .toolbar(.hidden, for: .navigationBar)

            // MARK: - Delete Alert

            .alert(
                "Delete Journal?",
                isPresented: $showingDeleteAlert
            ) {

                Button("Cancel", role: .cancel) {
                    journalToDelete = nil
                }

                Button("Delete", role: .destructive) {

                    if let journal = journalToDelete {
                        viewModel.deleteJournal(journal)
                    }

                    journalToDelete = nil
                }

            } message: {

                Text("Are you sure you want to delete this journal?")
            }

            // MARK: - Editor Sheet

            .sheet(isPresented: $showingEditor) {

                JournalEditorView(
                    viewModel: viewModel,
                    journal: selectedJournal
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }

            // MARK: - Refresh Journals

            .onChange(of: showingEditor) { _, isShowing in

                if !isShowing {
                    selectedJournal = nil
                    viewModel.fetchJournals()
                }
            }
        }
    }

    // MARK: - Header View

    private var headerView: some View {

        HStack {

            Text("Journal")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(JournalColors.primaryText)

            Spacer()

            HStack(spacing: 0) {

                // Filter Button

                Menu {

                    Button {

                        bookmarkedOnly.toggle()

                    } label: {

                        Label(
                            bookmarkedOnly
                                ? "Show All Journals"
                                : "Filter Bookmarked",
                            systemImage: "bookmark"
                        )
                    }

                    Divider()

                    Button {

                        sortByBookmark = true

                    } label: {

                        Label(
                            "Sort by Bookmark",
                            systemImage: "bookmark.fill"
                        )
                    }

                    Button {

                        sortByBookmark = false

                    } label: {

                        Label(
                            "Sort by Entry Date",
                            systemImage: "calendar"
                        )
                    }

                } label: {

                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 21))
                        .foregroundStyle(JournalColors.primaryText)
                        .frame(width: 54, height: 48)
                }

                // Add Journal Button

                Button {

                    selectedJournal = nil
                    showingEditor = true

                } label: {

                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundStyle(JournalColors.primaryText)
                        .frame(width: 48, height: 48)
                }
            }
            .background(JournalColors.cardBackground)
            .clipShape(Capsule())
            .overlay {

                Capsule()
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 16)
    }

    // MARK: - Journal List

    private var journalList: some View {

        List {

            ForEach(filteredJournals, id: \.id) { journal in

                JournalCardView(
                    journal: journal,

                    onBookmark: {
                        viewModel.toggleBookmark(journal)
                    },

                    onTap: {
                        selectedJournal = journal
                        showingEditor = true
                    }
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(
                        top: 8,
                        leading: 20,
                        bottom: 8,
                        trailing: 20
                    )
                )
                .swipeActions(
                    edge: .trailing,
                    allowsFullSwipe: false
                ) {

                    Button(role: .destructive) {

                        journalToDelete = journal
                        showingDeleteAlert = true

                    } label: {

                        Label("Delete", systemImage: "trash")
                    }
                    .tint(JournalColors.destructive)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(JournalColors.background)
    }

    // MARK: - Empty Search Results

    private var noResultsView: some View {

        VStack(spacing: 14) {

            Spacer()

            Image(systemName: "book.closed")
                .font(.system(size: 48))
                .foregroundStyle(JournalColors.textAccent)

            Text("No Journals Found")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(JournalColors.textAccent)

            Text("Try another search or change your filter.")
                .font(.system(size: 16))
                .foregroundStyle(JournalColors.secondaryText)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Search Bar

    private var searchBar: some View {

        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .foregroundStyle(JournalColors.secondaryText)

            TextField("Search", text: $searchText)
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .tint(JournalColors.primaryAccent)

            if !searchText.isEmpty {

                Button {

                    searchText = ""

                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(JournalColors.secondaryText)
                }
            }

            Image(systemName: "mic")
                .font(.system(size: 19))
                .foregroundStyle(JournalColors.secondaryText)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(JournalColors.cardBackground)
        .clipShape(Capsule())
        .overlay {

            Capsule()
                .stroke(.white.opacity(0.15), lineWidth: 1)
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(JournalColors.background)
    }
}
