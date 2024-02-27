//
//  testGauge1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/18/24.
//

import SwiftUI

struct ContentGaugeView: View {
    @State private var progress: Float = 0.0
    @State private var timer: Timer?
    let totalFileSize: Float = 1000000 // Example total file size in bytes

    var body: some View {
        VStack {
            Gauge1View(progress: progress)
                .frame(width: 200, height: 200)

            Button("Start File Creation") {
                startFileCreationProcess()
            }
        }
    }

    func startFileCreationProcess() {
        // Simulate file creation process here

        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateProgress()
        }
    }

    func updateProgress() {
        let currentFileSize = getCurrentFileSize()
        DispatchQueue.main.async {
            self.progress = Float(currentFileSize) / self.totalFileSize
            if self.progress >= 1.0 {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func getCurrentFileSize() -> Float {
        // Implement the logic to get the current file size
        // For simulation, just increase the size each time
        let simulatedIncrease = Float.random(in: 0..<50000)
        return min(progress * totalFileSize + simulatedIncrease, totalFileSize)
    }
}

struct Gauge1View: View {
    var progress: Float

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(String(format: "%.0f%%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}


//import SwiftUI
//
//struct testGauge1View: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

#Preview {
    ContentGaugeView()
}
