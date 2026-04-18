import SwiftUI

struct StopwatchView: View {
    @State private var model = StopwatchModel()

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: model.isRunning ? (1.0 / 30.0) : 60.0)) { context in
                StopwatchScreen(model: model, date: context.date)
                    .navigationTitle("SwiftUI Stopwatch")
                    .background(StopwatchBackground())
            }
        }
    }
}

private struct StopwatchScreen: View {
    let model: StopwatchModel
    let date: Date

    var body: some View {
        let display = model.display(at: date)

        ScrollView {
            VStack(spacing: 24) {
                DisplayView(display: display, isRunning: model.isRunning)

                HStack(spacing: 12) {
                    Button(action: { _ = model.recordLap() }) {
                        ActionButtonView(
                            title: "Lap",
                            systemImage: "flag.fill",
                            tint: .blue,
                            isEnabled: model.isRunning
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!model.isRunning)

                    Button(action: model.reset) {
                        ActionButtonView(
                            title: "Reset",
                            systemImage: "arrow.counterclockwise",
                            tint: .gray,
                            isEnabled: model.canReset && !model.isRunning
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!model.canReset || model.isRunning)

                    Button(action: { model.toggle() }) {
                        ActionButtonView(
                            title: model.isRunning ? "Stop" : "Start",
                            systemImage: model.isRunning ? "stop.fill" : "play.fill",
                            tint: model.isRunning ? .red : .green,
                            isEnabled: true
                        )
                    }
                    .buttonStyle(.plain)
                }

                lapsSection
            }
            .padding(20)
        }
    }

    @ViewBuilder
    private var lapsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Laps")
                .font(.title3.weight(.semibold))

            if model.laps.isEmpty {
                ContentUnavailableView(
                    "No Laps Yet",
                    systemImage: "flag.slash",
                    description: Text("Start the timer and tap Lap to build your history.")
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.thinMaterial)
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(model.laps) { lap in
                        LapRowView(lap: lap)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct LapRowView: View {
    let lap: LapTime

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(lap.title)
                    .font(.headline)

                Text("Total \(lap.totalText)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            VStack(alignment: .trailing, spacing: 6) {
                Text(lap.splitText)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(highlightColor)

                if let badgeText {
                    Text(badgeText)
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .foregroundStyle(highlightColor)
                        .background(highlightColor.opacity(0.14), in: Capsule())
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.thinMaterial)
        )
    }

    private var badgeText: String? {
        switch lap.highlight {
        case .fastest:
            "FASTEST"
        case .slowest:
            "SLOWEST"
        case .neutral:
            nil
        }
    }

    private var highlightColor: Color {
        switch lap.highlight {
        case .fastest:
            .green
        case .slowest:
            .orange
        case .neutral:
            .primary
        }
    }
}

private struct StopwatchBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(.systemGroupedBackground),
                Color(.secondarySystemGroupedBackground),
                Color.blue.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    StopwatchView()
}
