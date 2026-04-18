import SwiftUI

struct ActionButtonView: View {
    let title: String
    let systemImage: String
    let tint: Color
    let isEnabled: Bool

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))

            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .foregroundStyle(isEnabled ? Color.white : Color.secondary)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(isEnabled ? tint.gradient : Color(.tertiarySystemFill).gradient)
        )
        .opacity(isEnabled ? 1 : 0.75)
    }
}

#Preview {
    HStack(spacing: 12) {
        ActionButtonView(title: "Lap", systemImage: "flag.fill", tint: .blue, isEnabled: true)
        ActionButtonView(title: "Reset", systemImage: "arrow.counterclockwise", tint: .gray, isEnabled: false)
        ActionButtonView(title: "Start", systemImage: "play.fill", tint: .green, isEnabled: true)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
