//
//  ContentView.swift
//  Wazzee
//
//  Created by Christoph Blessing on 29.12.20.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var totalTime: TimeInterval = 0
    @State var timerLabel: String = "00:00:00"
    
    @ObservedObject private var locationManager = LocationManager()
    
    @State var timerIsRunning = false
    @State var startTime: Date!
    @State var timer: Timer!
    @State var buttonLabel = "Start"
        
    var body: some View {
        VStack {
            Spacer()
            Text("\(timerLabel)")
                .font(.system(size: 70))
                .padding()
            Text("Total Distance: \(Int(locationManager.totalDistance))m")
                .font(.system(size: 30))
                .padding()
            Spacer()
            HStack {
                Button(action: {
                    reset()
                }, label: {
                    Text("Reset")
                })
                .padding()
                .background(Color.red)
                .buttonStyle(BtnStyle())
                .cornerRadius(/*@START_MENU_TOKEN@*/40.0/*@END_MENU_TOKEN@*/)
                .disabled(timerIsRunning)
                .opacity(timerIsRunning ? 0.1 : 1)

                Spacer()
                Button(action: {
                    handleTimer()
                }, label: {
                    Text(buttonLabel)
                })
                .padding()
                .background(Color.shoeGreen)
                .buttonStyle(BtnStyle())
                .cornerRadius(40.0)
            }
            Spacer()
            Text("Wazzee")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding()
        }.background(Color.background)
    }
    
    func handleTimer() {
        if !timerIsRunning {
            runTimer()
            startTime = Date()
            timerIsRunning = true
            locationManager.start()
            buttonLabel = "Stop"
        } else {
            startTime = Date()
            timerIsRunning = false
            timer.invalidate()
            locationManager.stop()
            buttonLabel = "Start"
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
            let currentTimeInterval = Date().timeIntervalSince(startTime!)
            startTime = Date()
            totalTime = currentTimeInterval + totalTime
            let currentTimeStemp = Int(floor(totalTime))
            
            let hour = formatTime(time: currentTimeStemp / 3600)
            let minute = formatTime(time: (currentTimeStemp % 3600) / 60)
            let second = formatTime(time: (currentTimeStemp % 3600) % 60)
            
            timerLabel = "\(hour):\(minute):\(second)"
        }
    }
    
    func formatTime(time: Int) -> String {
        if (time < 10) {
            return "0\(time)"
        }
        return "\(time)"
    }
    
    func reset() {
        if (timer != nil) {
            timer.invalidate()
        }
        totalTime = 0
        timerLabel = "00:00:00"
        startTime = nil
        timerIsRunning = false
        locationManager.reset()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

extension Color {
    static let background = Color("background")
    static let shoeGreen = Color("primaryActionButton")
}

struct BtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding()
            .foregroundColor(Color.primary)
            .font(.system(size: 30))
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    
}
