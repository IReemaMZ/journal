
import SwiftUI

struct EmptyStateView: View {

    var body: some View {

        VStack(spacing: 18) {

            Spacer()

            // MARK: - Illustration

            Image("openjournal")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 130)
                .accessibilityLabel("Open journal notebook")

            // MARK: - Title

            Text("Begin Your Journal")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(JournalColors.textAccent)

            // MARK: - Description

            Text("Craft your personal diary, tap the\nplus icon to begin")
                .font(.system(size: 17))
                .foregroundStyle(JournalColors.primaryText)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(JournalColors.background)
    }
}

// MARK: - Preview

#Preview {
    EmptyStateView()
        .preferredColorScheme(.dark)
}
