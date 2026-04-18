import UIKit

final class LapTableViewCell: UITableViewCell {
    private let cardView = UIView()
    private let lapLabel = UILabel()
    private let totalLabel = UILabel()
    private let splitLabel = UILabel()
    private let badgeLabel = UILabel()
    private let leftStack = UIStackView()
    private let rightStack = UIStackView()
    private let contentStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(lap: LapTime) {
        lapLabel.text = lap.title
        totalLabel.text = "Total \(lap.totalText)"
        splitLabel.text = lap.splitText
        updateBadge(for: lap.highlight)
    }

    private func setupComponents() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .secondarySystemGroupedBackground
        cardView.layer.cornerRadius = 20

        lapLabel.translatesAutoresizingMaskIntoConstraints = false
        lapLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        lapLabel.textColor = .label
        lapLabel.numberOfLines = 1

        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.font = .systemFont(ofSize: 13, weight: .medium)
        totalLabel.textColor = .secondaryLabel
        totalLabel.numberOfLines = 1

        splitLabel.translatesAutoresizingMaskIntoConstraints = false
        splitLabel.font = .monospacedDigitSystemFont(ofSize: 24, weight: .semibold)
        splitLabel.textAlignment = .right
        splitLabel.textColor = .label
        splitLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.layer.masksToBounds = true
        badgeLabel.isHidden = true
        badgeLabel.setContentHuggingPriority(.required, for: .horizontal)
        badgeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        leftStack.translatesAutoresizingMaskIntoConstraints = false
        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.alignment = .leading

        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.axis = .vertical
        rightStack.spacing = 6
        rightStack.alignment = .trailing

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 16
        contentStack.distribution = .fill

        rightStack.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setupUI() {
        contentView.addSubview(cardView)
        leftStack.addArrangedSubview(lapLabel)
        leftStack.addArrangedSubview(totalLabel)
        rightStack.addArrangedSubview(splitLabel)
        rightStack.addArrangedSubview(badgeLabel)
        contentStack.addArrangedSubview(leftStack)
        contentStack.addArrangedSubview(UIView())
        contentStack.addArrangedSubview(rightStack)

        cardView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }

    private func updateBadge(for highlight: LapHighlight) {
        switch highlight {
        case .fastest:
            badgeLabel.isHidden = false
            badgeLabel.text = "FASTEST"
            badgeLabel.textColor = .systemGreen
            badgeLabel.backgroundColor = .systemGreen.withAlphaComponent(0.14)
            splitLabel.textColor = .systemGreen
        case .slowest:
            badgeLabel.isHidden = false
            badgeLabel.text = "SLOWEST"
            badgeLabel.textColor = .systemOrange
            badgeLabel.backgroundColor = .systemOrange.withAlphaComponent(0.14)
            splitLabel.textColor = .systemOrange
        case .neutral:
            badgeLabel.isHidden = true
            badgeLabel.text = nil
            badgeLabel.backgroundColor = .clear
            splitLabel.textColor = .label
        }
    }
}
