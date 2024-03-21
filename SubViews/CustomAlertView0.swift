//
//  CustomAlertView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/23/24.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var showAlert: Bool
    var imageName: String
    var title: String
    var message: String
    var fontSize1: CGFloat
    var fontSize2: CGFloat
    var textColor: Color
    var backgroundColor: Color
//    var onOK: () -> Void

    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundColor(textColor)
                .padding(10)
            Text(title)
                .font(.system(size: fontSize1))
                .foregroundColor(textColor)
                .padding(10)
            }
            Text(message)
                .font(.system(size: fontSize2))
                .foregroundColor(textColor)
                .padding(10)

            Button("OK") {
                showAlert = false
//                onOK()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .padding()
        }
        .frame(width: 300)  // , height: 140)
        .background(backgroundColor)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
//    @State private var showAlert = true
    CustomAlertView(
        showAlert: .constant(true),
                    imageName: "exclamationmark.triangle",
                    title: "Warning",
                    message: "The sparse container could not be created due to a password failure! 😡",
                    fontSize1: 16,
                    fontSize2: 14,
        textColor: Color(.white),
                    backgroundColor: Color("LL_blue")
//                    onOK: {print("OK pressed")}
    )
}

