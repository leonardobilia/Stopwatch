//
//  LapTime.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import Foundation

enum Section: CaseIterable {
    case main
}

struct LapTime: Decodable, Hashable {
    var title: String
    var time: String
}
