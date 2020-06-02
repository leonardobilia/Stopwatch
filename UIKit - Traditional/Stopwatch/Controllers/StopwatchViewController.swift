//
//  StopwatchViewController.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {
    
    private let reusableIdentifier = "SWCell"
    private lazy var tableView = UITableView()

    private lazy var minuteLabel = SWLabel()
    private lazy var secondLabel = SWLabel()
    private lazy var millisecondLabel = SWLabel()
    private lazy var primarySeparatorLabel = SWLabel()
    private lazy var secondarySeparatorLabel = SWLabel()
    
    private lazy var lapButton = SWButton()
    private lazy var resetButton = SWButton()
    private lazy var startStopButton = SWButton()
    
    private lazy var labelStackView = SWStackView()
    private lazy var buttonStackView = SWStackView()
    
    private lazy var lappedTimes = [LapTime]()
    private lazy var counter = 0.001
    private lazy var timerOn = false
    private var timer = Timer()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupComponents()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc private func timerHandler() {
        counter += 0.001
        
        let millisecond = counter * 1000
        let remaingMilliseconds = (Int(millisecond) % 1000) / 10
        let second = (Int(millisecond) / 1000) % 60
        let minute = (Int(millisecond) / 1000) / 60 % 60
        
        DispatchQueue.main.async {
            self.minuteLabel.text = String(format: "%02i", minute)
            self.secondLabel.text = String(format: "%02i", second)
            self.millisecondLabel.text = String(format: "%02i", remaingMilliseconds)
        }
    }
    
    @objc private func startStopHandler() {
        if timerOn {
            timer.invalidate()
        } else {
            let timer = Timer(timeInterval: 0.001, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.0001
            self.timer = timer
        }
        self.timerOn.toggle()
        DispatchQueue.main.async {
            self.startStopButton.setTitle(self.timerOn ? "Stop" : "Start", for: .normal)
            self.startStopButton.backgroundColor = self.timerOn ? .systemRed : .systemGreen
        }
    }
    
    @objc private func lapHandler() {
        guard let minute = minuteLabel.text, let second = secondLabel.text, let millisecond = millisecondLabel.text, timerOn else { return }
        
        let indexPath = IndexPath(row: lappedTimes.count, section: 0)
        lappedTimes.append(LapTime(title: "Lap \(indexPath.row + 1)", time: "\(minute):\(second):\(millisecond)"))
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc private func resetHandler() {
        lappedTimes = [LapTime]()
        timerOn = false
        counter = 0
        timer.invalidate()

        DispatchQueue.main.async {
            self.minuteLabel.setup(title: "00")
            self.secondLabel.setup(title: "00")
            self.millisecondLabel.setup(title: "00")
            self.startStopButton.setTitle("Start", for: .normal)
            self.startStopButton.backgroundColor = .systemGreen
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LapTableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = 50
    }
    
    func setupComponents() {
        minuteLabel.setup(title: "00")
        secondLabel.setup(title: "00")
        millisecondLabel.setup(title: "00")
        primarySeparatorLabel.setup(title: ":")
        secondarySeparatorLabel.setup(title: ":")
        
        labelStackView.setup(spacing: 0, distribution: .equalCentering)
        buttonStackView.setup(spacing: 16, distribution: .fillEqually)
        
        lapButton.setup(title: "Lap", color: .secondaryLabel)
        lapButton.addTarget(self, action: #selector(lapHandler), for: .touchUpInside)
        
        resetButton.setup(title: "Reset", color: .secondaryLabel)
        resetButton.addTarget(self, action: #selector(resetHandler), for: .touchUpInside)
        
        startStopButton.setup(title: "Start", color: .systemGreen)
        startStopButton.addTarget(self, action: #selector(startStopHandler), for: .touchUpInside)
    }
}

// MARK: - Table View Delegates and Data Sources

extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lappedTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! LapTableViewCell
        cell.selectionStyle = .none
        cell.populate(lap: lappedTimes[indexPath.row])
        return cell
    }
}


// MARK: - UI

extension StopwatchViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    
        view.addSubview(tableView)
        view.addSubview(minuteLabel)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(lapButton)
        buttonStackView.addArrangedSubview(resetButton)
        buttonStackView.addArrangedSubview(startStopButton)
        
        view.addSubview(labelStackView)
        labelStackView.addArrangedSubview(minuteLabel)
        labelStackView.addArrangedSubview(primarySeparatorLabel)
        labelStackView.addArrangedSubview(secondLabel)
        labelStackView.addArrangedSubview(secondarySeparatorLabel)
        labelStackView.addArrangedSubview(millisecondLabel)

        view.subviews.forEach({ element in
            element.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let width: CGFloat = (UIScreen.main.bounds.width / 3) - 28
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            minuteLabel.widthAnchor.constraint(equalToConstant: width),
            secondLabel.widthAnchor.constraint(equalToConstant: width),
            millisecondLabel.widthAnchor.constraint(equalToConstant: width),
            
            buttonStackView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 80),

            tableView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
