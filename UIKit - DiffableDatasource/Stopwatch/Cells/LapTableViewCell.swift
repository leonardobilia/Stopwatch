//
//  LapTableViewCell.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import UIKit

class LapTableViewCell: UITableViewCell {

    private lazy var lapLabel = UILabel()
    private lazy var timerLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func populate(lap: LapTime) {
        lapLabel.text = lap.title
        timerLabel.text = lap.time
    }
    
    func setupComponents() {
        lapLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UI

extension LapTableViewCell {
    
    private func setupUI() {
        
        contentView.addSubview(lapLabel)
        contentView.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            lapLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lapLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            timerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
