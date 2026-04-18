import UIKit

final class SWButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.buttonSize = .large
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 17, weight: .semibold)
            return outgoing
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(title: String, color: UIColor, isEnabled: Bool = true) {
        var updatedConfiguration = configuration ?? .filled()
        updatedConfiguration.title = title
        updatedConfiguration.baseBackgroundColor = isEnabled ? color : .tertiarySystemFill
        updatedConfiguration.baseForegroundColor = isEnabled ? .white : .secondaryLabel
        configuration = updatedConfiguration
        self.isEnabled = isEnabled
        alpha = isEnabled ? 1 : 0.72
    }
}
