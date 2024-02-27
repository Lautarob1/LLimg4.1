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
    

    var body: some View {
        VStack (spacing: 0) {
            Image("LLimager_Window2")
                .resizable()
                .frame(width: 320, height: 30)
                .scaledToFit()
                .padding(5)
            Spacer()
            VStack {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundColor(textColor)
                .padding(10)
            }
            Text(title)
                .font(.system(size: fontSize1))
                .foregroundColor(textColor)
                .padding(10)

            Text(message)
                .font(.system(size: fontSize2))
                .foregroundColor(textColor)
                .padding(10)

            Button("OK") {
                showAlert = false
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .padding()
        }
        .frame(width: 320, height: 270)
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
                    message: "Something went wrong! 😡",
                    fontSize1: 16,
                    fontSize2: 14,
                    textColor: Color("LL_blue"),
                    backgroundColor: Color(.white))

}

