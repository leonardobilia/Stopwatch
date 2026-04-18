import Foundation

struct LapTime: Hashable, Identifiable {
    let id = UUID()
    let number: Int
    let split: TimeInterval
    let total: TimeInterval
    var highlight: LapHighlight = .neutral

    var title: String {
        "Lap \(number)"
    }

    var splitText: String {
        StopwatchTimeFormatter.string(for: split)
    }

    var totalText: String {
        StopwatchTimeFormatter.string(for: total)
    }
}
