import Foundation

enum StopwatchTimeFormatter {
    static func display(for interval: TimeInterval) -> StopwatchDisplay {
        let centiseconds = max(0, Int((interval * 100).rounded(.down)))
        let minutes = centiseconds / 6_000
        let seconds = (centiseconds / 100) % 60
        let remainingCentiseconds = centiseconds % 100

        return StopwatchDisplay(
            minutes: String(format: "%02d", minutes),
            seconds: String(format: "%02d", seconds),
            centiseconds: String(format: "%02d", remainingCentiseconds)
        )
    }

    static func string(for interval: TimeInterval) -> String {
        let display = display(for: interval)
        return "\(display.minutes):\(display.seconds).\(display.centiseconds)"
    }
}
