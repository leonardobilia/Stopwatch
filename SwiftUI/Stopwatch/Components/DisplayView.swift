//
//  DisplayView.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import SwiftUI

struct DisplayView: View {
    
    var minutes: String
    var seconds: String
    var milliseconds: String
    
    var body: some View {
        HStack {
            Text(minutes)
                .frame(width: (UIScreen.main.bounds.width / 4))
            Text(":")
            Text(seconds)
                .frame(width: (UIScreen.main.bounds.width / 4))
            Text(":")
            Text(milliseconds)
                .frame(width: (UIScreen.main.bounds.width / 4))
        }
        .font(.system(size: 70))
        .padding()
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView(minutes: "00", seconds: "00", milliseconds: "00")
    }
}
