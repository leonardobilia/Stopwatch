//
//  SWButton.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import UIKit

class SWButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, color: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 40
        self.layer.masksToBounds = true
        self.backgroundColor = color
    }
}
