import UIKit

final class SWLabel: UILabel {
    enum Style {
        case timerValue
        case separator
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.55
        textAlignment = .center
        textColor = .label
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(title: String, style: Style = .timerValue) {
        text = title

        switch style {
        case .timerValue:
            font = .monospacedDigitSystemFont(ofSize: 60, weight: .bold)
        case .separator:
            font = .systemFont(ofSize: 44, weight: .semibold)
        }
    }
}
