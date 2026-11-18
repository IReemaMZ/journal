
import SwiftUI

struct SplashView: View {

    @State private var showNotebook = false
    @State private var showTitle = false
    @State private var showSubtitle = false

    var body: some View {

        ZStack {

            // MARK: - Background

            LinearGradient(
                colors: [
                    Color(red: 0.025, green: 0.025, blue: 0.035),
                    Color(red: 0.045, green: 0.045, blue: 0.060),
                    Color(red: 0.075, green: 0.075, blue: 0.095)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {

                Spacer()

                // MARK: - Notebook Illustration

                Image("closedjournal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125, height: 125)
                    .scaleEffect(showNotebook ? 1 : 0.65)
                    .opacity(showNotebook ? 1 : 0)
                    .offset(y: showNotebook ? 0 : 25)

                // MARK: - App Title

                Text("Journali")
                    .font(.system(size: 40, weight: .black))
                    .foregroundStyle(.white)
                    .scaleEffect(showTitle ? 1 : 0.85)
                    .opacity(showTitle ? 1 : 0)

                // MARK: - Tagline

                Text("Your thoughts, your story")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(
                        Color(
                            red: 163.0 / 255.0,
                            green: 154.0 / 255.0,
                            blue: 154.0 / 255.0
                        )
                    )
                    .opacity(showSubtitle ? 1 : 0)
                    .offset(y: showSubtitle ? 0 : 8)

                Spacer()
            }
        }

        // MARK: - Animations

        .onAppear {

            withAnimation(
                .spring(
                    response: 0.8,
                    dampingFraction: 0.7
                )
            ) {
                showNotebook = true
            }

            withAnimation(
                .easeOut(duration: 0.7).delay(0.5)
            ) {
                showTitle = true
            }

            withAnimation(
                .easeOut(duration: 0.7).delay(0.9)
            ) {
                showSubtitle = true
            }
        }

        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

#Preview {
    SplashView()
}
