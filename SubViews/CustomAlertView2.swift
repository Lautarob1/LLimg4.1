//
//  CustomAlertView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/23/24.
//

import SwiftUI

struct CustomAlertView2: View {
    @Binding var showAlert2: Bool
    var imageName: String
    var title: String
    var message: String
    var fontSize1: CGFloat
    var fontSize2: CGFloat
    var textColor: Color
    var backgroundColor: Color
    var onDismiss: () -> Void
  
    
    
    var body: some View {
        VStack (spacing: 0) {
            Spacer()
            VStack (spacing: 0){
                HStack {
                    Image(systemName: imageName)
                        .font(.largeTitle)
                        .foregroundColor(textColor)
                        .padding(5)
                    Text(title)
                        .font(.system(size: fontSize1))
                        .foregroundColor(textColor)
                        .padding(.trailing, 5)
                }
                .padding(.vertical, 5)
                Text(message)
                    .font(.system(size: fontSize2))
                    .foregroundColor(textColor)
                    .padding(3)
                
                Button("OK") {
                    showAlert2 = false
                    onDismiss()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .frame(width: 80)
                .padding(5)
            }
            .frame(width: 320, height: 140)
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
    
}


#Preview {
//    @State private var showAlert = true
    CustomAlertView2(
        showAlert2: .constant(true),
                    imageName: "exclamationmark.triangle",
                    title: "Error",
                    message: "Name is invalid! 🤔 ",
                    fontSize1: 20,
                    fontSize2: 14,
                    textColor: Color(.white),
                    backgroundColor: Color("LL_orange"),
                    onDismiss: {
                        print("OnDismiss")
                    })


}

