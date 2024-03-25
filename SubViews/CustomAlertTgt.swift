//
//  CustomAlertView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/23/24.
//

import SwiftUI

struct CustomAlertTgt: View {
//    @Binding var showAlert0: Bool
    let imageName: String = "img_but1"
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
    let textColor: Color = .white
    let backgroundColor2: Color = (Color.black.opacity(0.6))
    let backgroundColor1: Color = (Color.black.opacity(0.5))
    let backgroundColor: Color = Color("LL_blue").opacity(0.8)
//    var dismissAction: () -> Void
    var onOK: () -> Void


    var body: some View {
        VStack (spacing: 5) {
            VStack (alignment: .center) {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
//                        .font(.system(size: 18))
                        .foregroundColor(textColor)
                    Text("Caution")
                        .font(.system(size: fontSize1))
                        .foregroundColor(textColor)
                        .padding(5)
                }
            }
            

            
            VStack (alignment: .leading, spacing: 5) {
                Text("Make sure to have enough space on the destination disk.")
                    .font(.system(size: 12))
//                Text(message1b)
//                + Text(llImager)
//                .italic()
//                + Text(" is not doing the exact calculation because it may take too much time, depending on number of files of each selected folder.")
                }
            .font(.system(size: 10))
            .foregroundColor(textColor)
            .padding([.horizontal], 20)
            
 
            
            Button("OK") {
                onOK()
            }
            .background(Color("LL_blue"))
            .foregroundColor(.white)
            .padding(3)
        }
        .frame(width: 370, height: 95)  // )
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

#Preview {
//    @State private var showAlert = true
    CustomAlertTgt {
        
    }
}

