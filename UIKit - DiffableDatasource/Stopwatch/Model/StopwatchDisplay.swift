import Foundation

struct StopwatchDisplay: Hashable {
    let minutes: String
    let seconds: String
    let centiseconds: String

    var accessibilityLabel: String {
        "\(minutes) minutes, \(seconds) seconds, \(centiseconds) centiseconds"
    }
}
