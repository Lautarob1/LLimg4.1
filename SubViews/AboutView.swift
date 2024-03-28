//
//  CustomAlertView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/23/24.
//

import SwiftUI

struct AboutView: View {
//    @Binding var showAlert0: Bool
    let imageLogo: String = "img_but1"
    let llImager = "IMAGER"
    let message1a: String = "Full Disk Access Enabled for LL"
    let message1b: String = "LL"
    let message1c: String = " has full disk access: "
    let message1d: String = "System Preferences → Privacy and Security → Full Disk Access → ENABLE"

//    let message4: String
//    let message5: String
//    let message6: String
    let fontSize1: CGFloat = 14.0
    let fontSize2: CGFloat = 12.0
    let textColor: Color = Color("LL_blue")
    let backgroundColor2: Color = (Color.black.opacity(0.6))
    let backgroundColor1: Color = (Color.black.opacity(0.5))
    let backgroundColor: Color = Color("LL_blue").opacity(0.8)
//    var dismissAction: () -> Void
    var onOK: () -> Void


    var body: some View {
        HStack {
            HStack (spacing: 5) {
                
                VStack  {
                    Image("LLimg_AboutLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(30)
    //                    .cornerRadius(15)
//                    HStack (spacing: 50) {
//                        Image(systemName: "exclamationmark.triangle")
//    //                        .font(.system(size: 18))
//                            .foregroundColor(textColor)
//                        Text("Caution")
//                            .font(.system(size: fontSize1))
//                            .foregroundColor(textColor)
//                            .padding(5)
//    //                    Spacer(minLength: 100)
//                    }
//                    .padding([.leading, .trailing], 30)
                }
                
                VStack (alignment: .leading){
                    Spacer(minLength: 10)
                    Image("efi-logo_w200px")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .padding(2)
                    Text(message1b)
                    + Text(llImager)
                    .italic()
                    + Text(" Version 4.01")
                    Spacer(minLength: 50)
                    Text(message1b)
                    + Text(llImager)
                    .italic()
                    + Text(" is a product of e-forensics inc. Copyright 2023-2024. All rights reserved.")
                    Spacer(minLength: 50)
                    HStack (spacing: 100){
                        Spacer()
                        Button("OK") {
                            onOK()
                                   }
                                .frame(width: 50, height: 25)
                                .background(Color("LL_orange"))
                                .foregroundColor(Color(.black))
                                .cornerRadius(5.0)
                                .padding(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    }
                .font(.system(size: 11))
                .foregroundColor(textColor)
                .padding([.horizontal], 20)
            }

        }
        
        .frame(width: 500, height: 250)  // )
//        .background(.white)  //.opacity(0.6)
        .cornerRadius(15)
//        .shadow(radius: 10)
    }
}

#Preview {
//    @State private var showAlert = true
    AboutView {
        
    }
}

