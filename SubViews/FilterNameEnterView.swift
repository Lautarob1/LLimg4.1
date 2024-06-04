//
//  CustomAlertView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/23/24.
//

import SwiftUI

struct FilterNameEnterView: View {
    @Binding var showAlert: Bool
    @Binding var profileName: String
    var imageName: String = "pencil"
    var title: String = "Enter Profile Name"
    var message: String = ""
    var fontSize1: CGFloat = 14.0
    var fontSize2: CGFloat = 11.0
    var textColor: Color = .white
    var backgroundColor: Color = Color("LL_blue")
//    var onOK: () -> Void

    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Image(systemName: "pencil")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                .padding(5)
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(textColor)
                .padding(5)
            }
            TextField("enter profile name with NO extension", text: $profileName)
                .font(.system(size: fontSize1))
                .cornerRadius(8)
                .foregroundColor(.gray)
                .padding(7)

            Button("OK") {
                showAlert = false
                print("name entered: \(profileName)")
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .padding(5)
        }
        .frame(width: 240)  // , height: 140)
        .background(Color("LL_blue"))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
//    @State private var showAlert = true
    FilterNameEnterView(
        showAlert: .constant(true),
        profileName: .constant("profile name with NO extension")
//                    imageName: "pencil"
//                    title: "Enter Profile Name",
//                    message: ""
//                    fontSize1: 14,
//                    fontSize2: 10,
//        textColor: Color(.white),
//                    backgroundColor: Color("LL_blue")
//                    onOK: {print("OK pressed")}
    )
}

