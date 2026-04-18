import SwiftUI

struct DisplayView: View {
    let display: StopwatchDisplay
    let isRunning: Bool

    var body: some View {
        VStack(spacing: 18) {
            VStack(spacing: 6) {
                Text(isRunning ? "Running" : "Ready")
                    .font(.headline)
                    .foregroundStyle(isRunning ? Color.green : Color.secondary)

                Text("Built with native SwiftUI state and a TimelineView-driven display.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                timeText(display.minutes)
                separator
                timeText(display.seconds)
                separator
                timeText(display.centiseconds)
            }
            .accessibilityLabel(display.accessibilityLabel)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private var separator: some View {
        Text(":")
            .font(.system(size: 36, weight: .semibold, design: .rounded))
            .foregroundStyle(.secondary)
    }

    private func timeText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 56, weight: .bold, design: .rounded))
            .monospacedDigit()
            .contentTransition(.numericText())
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    DisplayView(
        display: StopwatchDisplay(minutes: "03", seconds: "42", centiseconds: "18"),
        isRunning: true
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
