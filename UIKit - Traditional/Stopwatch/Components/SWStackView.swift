//
//  SWStackView.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import UIKit

class SWStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.axis = .horizontal
        self.spacing = spacing
        self.distribution = distribution
    }
}
