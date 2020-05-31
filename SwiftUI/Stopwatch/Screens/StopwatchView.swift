//
//  StopwatchView.swift
//  Stopwatch
//
//  Created by Leonardo Bilia on 31/05/20.
//  Copyright © 2020 Leonardo Bilia. All rights reserved.
//

import SwiftUI

struct StopwatchView: View {

    @State var sourceTimer: DispatchSourceTimer?
    @State var lappedTimes = [LapTime]()
    @State var timerOn = false
    @State var milliseconds = "00"
    @State var seconds = "00"
    @State var minutes = "00"
    @State var counter = 0.0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            DisplayView(minutes: minutes, seconds: seconds, milliseconds: milliseconds)

            Spacer()
            HStack(spacing: 8) {
                Button(action: { self.lapHandler() }) {
                    ActionButtonView(style: .lap)
                }

                Button(action: { self.resetHandler() }) {
                    ActionButtonView(style: .reset)
                }

                Button(action: { self.startStopHandler() }) {
                    ActionButtonView(style: timerOn ? .stop : .start)
                }
            }
            .padding(.horizontal)
            List(lappedTimes, id: \.self) { lap in
                HStack {
                    Text(lap.title)
                    Spacer()
                    Text(lap.time)
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2.2)
        }
    }

    // MARK: - Methods
    
    func startStopHandler() {
        if timerOn {
            sourceTimer?.suspend()
        } else {
            self.sourceTimer = DispatchSource.makeTimerSource(flags: .strict, queue: .main)
            self.sourceTimer?.setEventHandler { self.updateTimer() }
            self.sourceTimer?.schedule(deadline: .now(), repeating: 0.001)
            self.sourceTimer?.resume()
        }
        timerOn.toggle()
    }

    func updateTimer() {
        counter += 0.001
        let millisecond = counter * 1000
        let remaingMilliseconds = (Int(millisecond) % 1000) / 10
        let second = (Int(millisecond) / 1000) % 60
        let minute = (Int(millisecond) / 1000) / 60 % 60

        DispatchQueue.main.async {
            self.minutes = String(format: "%02i", minute)
            self.seconds = String(format: "%02i", second)
            self.milliseconds = String(format: "%02i", remaingMilliseconds)
        }
    }

    func lapHandler() {
        let laps = lappedTimes.count + 1
        lappedTimes.append(LapTime(title: "Lap \(laps)", time: "\(minutes):\(seconds):\(milliseconds)"))
    }

    func resetHandler() {
        sourceTimer?.suspend()
        lappedTimes.removeAll()
        timerOn = false
        DispatchQueue.main.async {
            self.counter = 0
            self.minutes = "00"
            self.seconds = "00"
            self.milliseconds = "00"
        }
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
    }
}
