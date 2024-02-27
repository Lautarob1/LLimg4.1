//
//  LLprogressView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/11/24.
//

import SwiftUI

struct LLprogressView: View {
    @State var titleImgSize: String = "Image Size"
    @State var titleGauge: String = "Disk Size"
    @State var ElapTime: String = "Elapsed Time"
    @State var imageSize: String = "Image Size in GB"
    @State var strokeWidth: CGFloat = 30
    @State var minValue: CGFloat = 0.0
    @State var maxValue: CGFloat = 0.7
    @State var currentValue: CGFloat = 0.6
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color.gray]),
                      startPoint: .top,
                      endPoint: .bottom)
    
    var body: some View {
        VStack (spacing: 0) {
            HStack(spacing: 0) { // Set spacing to 0 if you don't want any space between the VStacks
                    Text(titleImgSize)
                .frame(width: 300, height: 40)
                .background(Color("LL_orange"))

                VStack {
                    // Content of the second VStack
                    Text(titleGauge)
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 40)
                .padding(.horizontal)
                .background(Color("LL_orange")) // Background color for visualization

                VStack {
                    // Content of the third VStack
                    let dmgtimerelapsedTimeString = "00:00:00"
                    Text("\(dmgtimerelapsedTimeString)")
                        .font(.system(size: 14, weight: .medium, design: .default)) // Customize the font here
                        .frame(width: 130, height: 25)
                        .padding(2) // Add padding around the text
                        .background(Color.blue) // Set the background color
                        .foregroundColor(.white) // Set the text color
                        .cornerRadius(8)
                }
                .frame(width: 300, height: 40)
                .background(Color("LL_orange")) // Background color for visualization
            }
            .frame(width: 900)
        .padding(0)
         // Setting the total width of the
        
        HStack(spacing: 0) { // Set spacing to 0 if you don't want any space between the VStacks
            VStack {
                // Content of the first VStack
                let fileSizeCheckerfileSizeInGB = 20.0
                Text("\(fileSizeCheckerfileSizeInGB, specifier: "%.2f") GB")
                    .font(.system(size: 24, weight: .medium, design: .default)) // Customize the font here
                    .frame(minWidth: 130, minHeight: 40)
                    .padding(2) // Add padding around the text
                    .background(Color("LL_blue")) // Set the background color
                    .foregroundColor(.white) // Set the text color
                    .cornerRadius(8)
            }
            .frame(width: 300, height: 170)
            .padding()
            .background(gradient) // Background color for visualization

            VStack {
                // Content of the second VStack
//                Text("VStack 2")
                GaugeView(
                    strokeWidth: strokeWidth,
                      foregroundColor: .white,
                      backgroundColor: .blue,
                    textSize: .title, minValue: minValue,
                    maxValue: maxValue,
                    currentValue: currentValue)
                
            }
            .frame(width: 300, height: 170)
            .padding()
            .background(gradient)
            VStack {
                // Content of the third VStack
                CustomProgressView(scale: 4, color: .blue, backgroundColor: .clear, currrentValue: currentValue)
            }
            .padding(.trailing)
            .frame(width: 300, height: 170)
            .padding()
            .background(gradient) // Background color for visualization
        }
        .frame(width: 900)
        .padding(0)
        .background(gradient)
        }
    }

}

#Preview {
    LLprogressView()
}

//from img2ProcRev (subsituted by this view with size adjustments
//                    VStack {
//                        Text("Temporal img size")
//                            .font(.system(size: 12, weight: .medium, design: .default)) //
//                        Text("\(fileSizeChecker.fileSizeInGB, specifier: "%.2f") GB")
//                            .font(.system(size: 14, weight: .medium, design: .default)) // Customize the font here
//                            .frame(minWidth: 130, minHeight: 25)
//                            .padding(2) // Add padding around the text
//                            .background(Color.blue) // Set the background color
//                            .foregroundColor(.white) // Set the text color
//                            .cornerRadius(8)
//                    }
//                    .padding(.horizontal, 35)
//                    if showdmgvalues {
//                        VStack {
//                            Text("DMG img size")
//                                .font(.system(size: 12, weight: .medium, design: .default)) //
//                            Text("\(fileSizeChecker2.fileSizeInGB, specifier: "%.2f") GB")
//                                .font(.system(size: 14, weight: .medium, design: .default)) // Customize the font here
//                                .frame(minWidth: 130, minHeight: 25)
//                                .padding(2) // Add padding around the text
//                                .background(Color.blue) // Set the background color
//                                .foregroundColor(.white) // Set the text color
//                                .cornerRadius(8)
//                        }
//                        .padding(.horizontal, 0)
//
//                        VStack {
//                            Text("DMG Elapsed Time")
//                                .font(.system(size: 12, weight: .medium, design: .default)) //
//                            Text("\(dmgtimer.elapsedTimeString)")  // "00:00:00" \(dmgtimer.elapsedTimeString)")
//                                .font(.system(size: 14, weight: .medium, design: .default)) // Customize the font here
//                                .frame(width: 130, height: 25)
//                                .padding(2) // Add padding around the text
//                                .background(Color.blue) // Set the background color
//                                .foregroundColor(.white) // Set the text color
//                                .cornerRadius(8)
//                        }
//                        .padding(.horizontal, 15)
//                    }
//                    VStack {
//                        Text("Temp Elapsed Time")
//                            .font(.system(size: 12, weight: .medium, design: .default)) //
//                        Text("\(timer.elapsedTimeString)")  // "00:00:00" \(timer.elapsedTimeString)")
//                            .font(.system(size: 15, weight: .medium, design: .default)) // Customize the font here
//                            .frame(width: 130, height: 25)
//                            .padding(2) // Add padding around the text
//                            .background(Color.blue) // Set the background color
//                            .foregroundColor(.white) // Set the text color
//                            .cornerRadius(8)
//                    }
//                    .padding(.horizontal, 20)
