//
//  ActionButtonView.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import SwiftUI

struct ActionButtonView: View {
    
    enum Style {
        case lap, reset, start, stop
        
        var title: String {
            switch self {
            case .lap: return "Lap"
            case .reset: return "Reset"
            case .start: return "Start"
            case .stop: return "Stop"
            }
        }
        
        var color: Color {
            switch self {
            case .lap, .reset: return Color(.systemGray)
            case .start: return Color(.systemGreen)
            case .stop: return Color(.systemRed)
            }
        }
    }
    
    var style: Style

    var body: some View {
        HStack {
            Spacer()
            Text(style.title)
                .foregroundColor(Color(.white))
            Spacer()
        }
        .frame(height: 80)
        .background(style.color.cornerRadius(.infinity))
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView(style: .start)
    }
}
