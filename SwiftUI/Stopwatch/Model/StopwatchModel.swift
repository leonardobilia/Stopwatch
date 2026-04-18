import Foundation
import Observation

@Observable
final class StopwatchModel {
    private var accumulatedTime: TimeInterval = 0
    private var startedAt: Date?
    private var lastLapMark: TimeInterval = 0

    private(set) var laps: [LapTime] = []

    var isRunning: Bool {
        startedAt != nil
    }

    var canReset: Bool {
        accumulatedTime > 0 || startedAt != nil || !laps.isEmpty
    }

    func toggle(at date: Date = .now) {
        isRunning ? stop(at: date) : start(at: date)
    }

    func start(at date: Date = .now) {
        guard startedAt == nil else { return }
        startedAt = date
    }

    func stop(at date: Date = .now) {
        guard startedAt != nil else { return }
        accumulatedTime = elapsedTime(at: date)
        startedAt = nil
    }

    func reset() {
        accumulatedTime = 0
        startedAt = nil
        lastLapMark = 0
        laps.removeAll()
    }

    @discardableResult
    func recordLap(at date: Date = .now) -> LapTime? {
        guard isRunning else { return nil }

        let total = elapsedTime(at: date)
        let split = max(0, total - lastLapMark)
        lastLapMark = total

        laps.insert(
            LapTime(number: laps.count + 1, split: split, total: total),
            at: 0
        )
        classifyLaps()
        return laps.first
    }

    func elapsedTime(at date: Date = .now) -> TimeInterval {
        guard let startedAt else { return accumulatedTime }
        return accumulatedTime + date.timeIntervalSince(startedAt)
    }

    func display(at date: Date = .now) -> StopwatchDisplay {
        StopwatchTimeFormatter.display(for: elapsedTime(at: date))
    }

    private func classifyLaps() {
        guard laps.count > 1 else {
            laps = laps.map(\.neutralizedHighlight)
            return
        }

        let rankedSplits = laps.map { Int(($0.split * 100).rounded(.down)) }
        guard let fastest = rankedSplits.min(), let slowest = rankedSplits.max(), fastest != slowest else {
            laps = laps.map(\.neutralizedHighlight)
            return
        }

        laps = laps.map { lap in
            let split = Int((lap.split * 100).rounded(.down))
            switch split {
            case fastest:
                return lap.highlighted(as: .fastest)
            case slowest:
                return lap.highlighted(as: .slowest)
            default:
                return lap.highlighted(as: .neutral)
            }
        }
    }
}

private extension LapTime {
    var neutralizedHighlight: Self {
        highlighted(as: .neutral)
    }

    func highlighted(as highlight: LapHighlight) -> Self {
        var copy = self
        copy.highlight = highlight
        return copy
    }
}
