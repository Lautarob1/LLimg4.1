//
//  testProgressView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/9/24.
//

import SwiftUI


struct CustomGauge2View: View {
    @Binding var currentValue: CGFloat
    @Binding var maxValue: CGFloat
    var font: Font = .title
    var backgroundColor: Color = .white
    var foregroundColor: Color = .blue

    private var percentage: CGFloat {
        return (currentValue / maxValue) * 100
    }

    var body: some View {
//        Text("disk capacity")
//            .offset(y: -75.0)
        ZStack {

//            Spacer()
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(foregroundColor)
                .frame(width: 150, height: 80)

            Circle()
                .trim(from: 0.0, to: percentage * 0.01)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(foregroundColor)
                .frame(width: 150, height: 80)
                .rotationEffect(Angle(degrees: 270.0))

            Text(String(format: "%.0f%%", percentage))
                .font(font)
                .foregroundColor(foregroundColor)
        }
        .padding()
        .background(backgroundColor)
    }
}


struct CustomGaugeView: View {
    var currentValue: CGFloat
    let maxValue: CGFloat = 500
    var font: Font = .title
    var backgroundColor: Color
    var foregroundColor: Color = .blue

    private var percentage: CGFloat {
        return (currentValue / maxValue) * 100
    }

    var body: some View {
//        Text("disk capacity")
//            .offset(y: -75.0)
        ZStack {

//            Spacer()
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(foregroundColor)
                .frame(width: 150, height: 80)

            Circle()
                .trim(from: 0.0, to: percentage * 0.01)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(foregroundColor)
                .frame(width: 150, height: 80)
                .rotationEffect(Angle(degrees: 270.0))

            Text(String(format: "%.0f%%", percentage))
                .font(font)
                .foregroundColor(foregroundColor)
        }
        .padding()
        .background(backgroundColor)
    }
}

import Foundation

//var progressInfo = 0
//
//func updateProgress() {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//        // Increase progressInfo by 10
//        progressInfo += 10
//        print("Progress: \(progressInfo)")
//
//        // Check if the condition is met
//        if progressInfo < 500 {
//            updateProgress() // Call the function recursively
//        } else {
//            print("Progress completed")
//        }
//    }
//}

// Example usage
//updateProgress()

    

//// Example Usage
//struct ContentView: View {
//    var body: some View {
//        CustomGaugeView(currentValue: 250, font: .largeTitle, backgroundColor: .gray)
//    }
//}




struct testProgressView: View {
    @State private var fileSize: Int = 0
    @State var currentValue: CGFloat
    @State var maxValue: CGFloat
    let radialGradient = RadialGradient(gradient: Gradient(colors: [Color.orange, Color.gray]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 100)
// fileSize = fileSizeChecker.fileSizeInGB
    
    var body: some View {
        HStack {
            VStack {
                Text("  ")
                    .font(.system(size: 12, weight: .medium, design: .default)) //
                Text("\(fileSize, specifier: "%.2f") GB")
                    .font(.system(size: 14, weight: .medium, design: .default)) // Customize the font here
                    .frame(width: 130, height: 70)

                    .background(Color.blue) // Set the background color
                    .cornerRadius(8)
                    .padding(25) // Add padding around the text
                    .foregroundColor(.white) // Set the text color

            }
//            .padding(.horizontal, 35)
            .background(.orange)
            VStack {
//                Text("   ")
//                    .font(.system(size: 12, weight: .medium, design: .default)) //
                CustomGaugeView(currentValue: CGFloat(fileSize), font: .headline, backgroundColor: .clear)
                    .frame(width: 200, height: 150)
            }
            .frame(width: 200, height: 200)
//            .padding(.horizontal, 35)
            VStack {
                if fileSize < 500 {
                    ProgressView()
                        .accentColor(.blue)
                         /*.progressViewStyle(CircularProgressViewStyle(tint: .blue))*/ // Set the color to blue
                         .scaleEffect(2) // Adjust the scale to fit the desired size
                         .frame(width: 130, height: 130)
                } else {
                    Text("Image completed")
                        .font(.system(size: 14, weight: .medium, design: .default)) // Customize the font here
                        .frame(width: 130, height: 30)
                        .padding(2) // Add padding around the text
                        .background(Color.blue) // Set the background color
                        .foregroundColor(.white) // Set the text color
                        .cornerRadius(8)
                }
                
            }
//            .background(Color("LL_orange"))
//            .frame(width: 200)
        }
        .frame(width: 600, height: 150)
        .background(Color("LL_orange"))
        .onAppear() {
            maxValue = 1000
            updateProgress()
        }
    }
    
    func updateProgress() {
        if fileSize < 500 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fileSize += 10
                self.updateProgress()
            }
        }
    }
    
 
}

#Preview {
    testProgressView(currentValue: 0, maxValue: 500)
}
