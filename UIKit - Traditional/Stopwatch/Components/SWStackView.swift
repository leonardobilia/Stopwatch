import UIKit

final class SWStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat,
        distribution: UIStackView.Distribution,
        alignment: UIStackView.Alignment = .fill
    ) {
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
}
