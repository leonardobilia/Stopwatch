import UIKit

final class StopwatchViewController: UIViewController {
    private enum Layout {
        static let heroInset: CGFloat = 16
        static let contentSpacing: CGFloat = 18
        static let tableTopSpacing: CGFloat = 14
        static let buttonHeight: CGFloat = 56
    }

    private let reusableIdentifier = "LapCell"
    private let engine = StopwatchEngine()

    private let heroCard = UIView()
    private let subtitleLabel = UILabel()
    private let emptyStateLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)

    private let minuteLabel = SWLabel()
    private let secondLabel = SWLabel()
    private let millisecondLabel = SWLabel()
    private let primarySeparatorLabel = SWLabel()
    private let secondarySeparatorLabel = SWLabel()

    private let lapButton = SWButton()
    private let resetButton = SWButton()
    private let startStopButton = SWButton()

    private let labelStackView = SWStackView()
    private let buttonStackView = SWStackView()

    private var displayLink: CADisplayLink?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Traditional UIKit"
        navigationItem.largeTitleDisplayMode = .always
        setupTableView()
        setupComponents()
        setupUI()
        render()
    }

    deinit {
        displayLink?.invalidate()
    }

    @objc private func startStopHandler() {
        engine.toggle()
        updateDisplayLinkState()
        render()
    }

    @objc private func lapHandler() {
        guard engine.recordLap() != nil else { return }
        tableView.reloadData()
        render()
    }

    @objc private func resetHandler() {
        engine.reset()
        updateDisplayLinkState()
        tableView.reloadData()
        render()
    }

    @objc private func updateElapsedTime() {
        renderElapsedTime()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LapTableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88

        emptyStateLabel.text = "Start the timer and capture laps."
        emptyStateLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 140)
        tableView.backgroundView = emptyStateLabel
    }

    private func setupComponents() {
        view.backgroundColor = .systemGroupedBackground

        heroCard.translatesAutoresizingMaskIntoConstraints = false
        heroCard.backgroundColor = .secondarySystemGroupedBackground
        heroCard.layer.cornerRadius = 28
        heroCard.layer.cornerCurve = .continuous

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Classic UITableViewDataSource + UITableViewDelegate"
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        minuteLabel.setup(title: "00")
        secondLabel.setup(title: "00")
        millisecondLabel.setup(title: "00")
        primarySeparatorLabel.setup(title: ":", style: .separator)
        secondarySeparatorLabel.setup(title: ":", style: .separator)

        labelStackView.setup(spacing: 10, distribution: .fill, alignment: .center)
        buttonStackView.setup(spacing: 12, distribution: .fillEqually)

        lapButton.setup(title: "Lap", color: .systemBlue, isEnabled: false)
        lapButton.accessibilityIdentifier = "stopwatch.lap"
        lapButton.addTarget(self, action: #selector(lapHandler), for: .touchUpInside)

        resetButton.setup(title: "Reset", color: .secondaryLabel, isEnabled: false)
        resetButton.accessibilityIdentifier = "stopwatch.reset"
        resetButton.addTarget(self, action: #selector(resetHandler), for: .touchUpInside)

        startStopButton.setup(title: "Start", color: .systemGreen)
        startStopButton.accessibilityIdentifier = "stopwatch.startStop"
        startStopButton.addTarget(self, action: #selector(startStopHandler), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(heroCard)
        view.addSubview(buttonStackView)
        view.addSubview(tableView)

        heroCard.addSubview(subtitleLabel)
        heroCard.addSubview(labelStackView)

        labelStackView.addArrangedSubview(minuteLabel)
        labelStackView.addArrangedSubview(primarySeparatorLabel)
        labelStackView.addArrangedSubview(secondLabel)
        labelStackView.addArrangedSubview(secondarySeparatorLabel)
        labelStackView.addArrangedSubview(millisecondLabel)

        buttonStackView.addArrangedSubview(lapButton)
        buttonStackView.addArrangedSubview(resetButton)
        buttonStackView.addArrangedSubview(startStopButton)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            heroCard.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            heroCard.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Layout.heroInset),
            heroCard.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Layout.heroInset),

            subtitleLabel.topAnchor.constraint(equalTo: heroCard.topAnchor, constant: 22),
            subtitleLabel.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor, constant: -20),

            labelStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            labelStackView.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor, constant: -16),
            labelStackView.bottomAnchor.constraint(equalTo: heroCard.bottomAnchor, constant: -22),

            minuteLabel.widthAnchor.constraint(equalTo: secondLabel.widthAnchor),
            secondLabel.widthAnchor.constraint(equalTo: millisecondLabel.widthAnchor),
            primarySeparatorLabel.widthAnchor.constraint(equalToConstant: 14),
            secondarySeparatorLabel.widthAnchor.constraint(equalToConstant: 14),

            buttonStackView.topAnchor.constraint(equalTo: heroCard.bottomAnchor, constant: Layout.contentSpacing),
            buttonStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Layout.heroInset),
            buttonStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Layout.heroInset),
            buttonStackView.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),

            tableView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: Layout.tableTopSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func render() {
        renderElapsedTime()
        lapButton.setup(title: "Lap", color: .systemBlue, isEnabled: engine.isRunning)
        resetButton.setup(title: "Reset", color: .secondaryLabel, isEnabled: engine.canReset && !engine.isRunning)
        startStopButton.setup(
            title: engine.isRunning ? "Stop" : "Start",
            color: engine.isRunning ? .systemRed : .systemGreen
        )
        emptyStateLabel.isHidden = !engine.laps.isEmpty
    }

    private func renderElapsedTime() {
        let display = engine.display()
        minuteLabel.text = display.minutes
        secondLabel.text = display.seconds
        millisecondLabel.text = display.centiseconds
        view.accessibilityLabel = "Stopwatch"
        view.accessibilityValue = display.accessibilityLabel
    }

    private func updateDisplayLinkState() {
        displayLink?.invalidate()
        displayLink = nil

        guard engine.isRunning else { return }

        let displayLink = CADisplayLink(target: self, selector: #selector(updateElapsedTime))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
}

extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        engine.laps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! LapTableViewCell
        cell.populate(lap: engine.laps[indexPath.row])
        return cell
    }
}
