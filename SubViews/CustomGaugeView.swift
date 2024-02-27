//
//  CustomGaugeView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/10/24.
//
struct Custom2GaugeView: View {
    var currentValue: CGFloat
    let maxValue: CGFloat = 500
    var font: Font = .title
    var backgroundColor: Color = .clear
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



import SwiftUI

struct GaugeView: View {
    @State var strokeWidth: CGFloat
    var foregroundColor: Color
    var backgroundColor: Color
    var backgroundColorC1: Color = .gray
    var textSize: Font
    @State var minValue: CGFloat
    @State var maxValue: CGFloat
    @State var currentValue: CGFloat
    

    
    

    var body: some View {
        let percentage = (currentValue / maxValue) * 100
        ZStack {
            Circle()
                .stroke(backgroundColorC1, lineWidth: strokeWidth)
                .frame(width: 120)
            Circle()
                .trim(from: CGFloat(minValue), to: CGFloat(maxValue)) // Example progress
                .stroke(foregroundColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(Angle(degrees: 270))
                .frame(width: 120)
            Text(String(format: "%.2f", currentValue))
                .font(textSize)
                .foregroundColor(foregroundColor)
        }
        .frame(width: 120, height: 120)
        .padding()
    }
}

//
//#Preview {
//    let strokew = 20.0
//    let minValue = 0
//    let maxValue = 100
//    let currrentVal = 50
//    GaugeView(strokeWidth: CGFloat(strokew), foregroundColor: .red,  backgroundColor: .blue, backgroundColorC1: .blue, textSize: .headline, minValue: CGFloat(minValue), maxValue: CGFloat(maxValue), currentValue: CGFloat(currentVal))
//}
