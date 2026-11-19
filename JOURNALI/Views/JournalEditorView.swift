
import SwiftUI

struct JournalEditorView: View {

    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: JournalViewModel

    let journal: Journal?

    @State private var title: String
    @State private var content: String

    @State private var showingDiscardAlert = false

    // MARK: - Colors

    private let backgroundColor = Color(
        red: 28.0 / 255.0,
        green: 28.0 / 255.0,
        blue: 30.0 / 255.0
    )

    private let buttonBackground = Color(
        red: 48.0 / 255.0,
        green: 48.0 / 255.0,
        blue: 50.0 / 255.0
    )

    private let placeholderColor = Color(
        red: 142.0 / 255.0,
        green: 142.0 / 255.0,
        blue: 147.0 / 255.0
    )

    private let cursorColor = Color(
        red: 139.0 / 255.0,
        green: 128.0 / 255.0,
        blue: 255.0 / 255.0
    )

    // MARK: - Initializer

    init(
        viewModel: JournalViewModel,
        journal: Journal? = nil
    ) {
        self.viewModel = viewModel
        self.journal = journal

        _title = State(initialValue: journal?.title ?? "")
        _content = State(initialValue: journal?.content ?? "")
    }

    // MARK: - Check Changes

    private var hasChanges: Bool {
        title != (journal?.title ?? "") ||
        content != (journal?.content ?? "")
    }

    private var isTitleEmpty: Bool {
        title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Top Bar

            HStack {

                // Close Button

                Button {
                    if hasChanges {
                        withAnimation(.spring(response: 0.35)) {
                            showingDiscardAlert = true
                        }
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(buttonBackground)
                        .clipShape(Circle())
                }

                Spacer()

                // Save Button

                Button(action: saveJournal) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 23, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 48, height: 48)
                        .background(cursorColor)
                        .clipShape(Circle())
                }
                .disabled(isTitleEmpty)
                .opacity(isTitleEmpty ? 0.5 : 1)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // MARK: - Title

            TextField(
                "",
                text: $title,
                prompt: Text("Title")
                    .foregroundColor(placeholderColor)
            )
            .font(.system(size: 32, weight: .bold))
            .foregroundStyle(.white)
            .tint(cursorColor)
            .padding(.horizontal, 20)
            .padding(.top, 28)

            // MARK: - Date

            Text(
                journal?.createdAt.formatted(
                    date: .numeric,
                    time: .omitted
                ) ?? Date.now.formatted(
                    date: .numeric,
                    time: .omitted
                )
            )
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(placeholderColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // MARK: - Journal Content

            ZStack(alignment: .topLeading) {

                // Text Editor

                TextEditor(text: $content)
                    .font(.system(size: 19, weight: .regular))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .tint(cursorColor)

                // Placeholder

                if content.isEmpty {
                    Text("Type your Journal...")
                        .font(.system(size: 19, weight: .regular))
                        .foregroundStyle(placeholderColor)
                        .padding(.leading, 5)
                        .padding(.top, 8)
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 20)

            Spacer(minLength: 0)
        }
        .background(
            backgroundColor.ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled(hasChanges)

        // MARK: - Discard Alert

        .overlay {
            if showingDiscardAlert {
                discardChangesOverlay
                    .transition(
                        .opacity.combined(
                            with: .move(edge: .top)
                        )
                    )
                    .zIndex(1)
            }
        }
    }

    // MARK: - Glossy Discard Popup

    private var discardChangesOverlay: some View {

        ZStack(alignment: .top) {

            // Dim Background

            Color.black.opacity(0.30)
                .ignoresSafeArea()

            // Glass Popup

            VStack(alignment: .leading, spacing: 22) {

                Text(
                    "Are you sure you want to discard changes on this journal?"
                )
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)

                // Discard Button

                Button {
                    withAnimation(.spring(response: 0.35)) {
                        showingDiscardAlert = false
                    }
                    dismiss()
                } label: {
                    Text("Discard Changes")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.20),
                                            Color.white.opacity(0.10),
                                            Color.white.opacity(0.16)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay {
                                    Capsule()
                                        .stroke(
                                            Color.white.opacity(0.10),
                                            lineWidth: 1
                                        )
                                }
                        }
                }

                // Keep Editing Button

                Button {
                    withAnimation(.spring(response: 0.35)) {
                        showingDiscardAlert = false
                    }
                } label: {
                    Text("Keep Editing")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.20),
                                            Color.white.opacity(0.10),
                                            Color.white.opacity(0.16)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay {
                                    Capsule()
                                        .stroke(
                                            Color.white.opacity(0.10),
                                            lineWidth: 1
                                        )
                                }
                        }
                }
            }
            .padding(18)
            .frame(maxWidth: 420)
            .background {
                RoundedRectangle(cornerRadius: 38)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .overlay {
                        RoundedRectangle(cornerRadius: 38)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.07),
                                        Color.black.opacity(0.20),
                                        Color.white.opacity(0.03)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 38)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.35),
                                Color.white.opacity(0.08),
                                Color.white.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .shadow(
                color: .black.opacity(0.4),
                radius: 20,
                y: 10
            )
            .padding(.horizontal, 14)
            .padding(.top, 14)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Save Journal

    private func saveJournal() {

        guard !isTitleEmpty else {
            return
        }

        if let journal {
            viewModel.updateJournal(
                journal,
                title: title,
                content: content
            )
        } else {
            viewModel.addJournal(
                title: title,
                content: content
            )
        }

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    Text("Journal Editor Preview")
        .preferredColorScheme(.dark)
}
