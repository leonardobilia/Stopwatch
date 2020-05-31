//
//  SWLabel.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import UIKit

class SWLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String) {
        self.text = title
        self.font = UIFont.systemFont(ofSize: 75)
        self.textAlignment = .center
    }
}
