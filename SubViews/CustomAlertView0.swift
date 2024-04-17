//
//  CustomAlertView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/23/24.
//

import SwiftUI

struct CustomAlertView0: View {
//    @Binding var showAlert0: Bool
    let imageName: String = "img_but1"
    let llImager = "IMAGER"
    let message1a: String = "Full Disk Access Enabled for LL"
    let message1b: String = ": Make sure LL"
    let message1c: String = " has full disk access: "
    let message1d: String = "System Preferences → Privacy and Security → Full Disk Access → ENABLE"
    let message2a: String = "Power Connection: "
    let message2b: String = "Connect your Mac to a stable power source"
    let message3a: String = "Close Other Apps: "
    let message3b: String = "Important for Targetted collections - close any unnecessary applications"
    let message4a: String = "Disk Space and Health: "
    let message4b: String = "LL"
    let message4c: String = " perform resource requirements checks. Nevertheless, confirm the destination drive has adequate space and is healthy (use Disk Utility in another Mac)"
    let message5a: String = "Post-Imaging: "
    let message5b: String = "After imaging, safely eject the external drive and verify the image (visual and hash based)"
    let message6a: String = "Back Up Data: "
    let message6b: String = "Ensure important data on the source is backed up"

//    let message4: String
//    let message5: String
//    let message6: String
    let fontSize1: CGFloat = 18.0
    let fontSize2: CGFloat = 14.0
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
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(textColor)
                    Text("Best Practices Checklist")
                        .font(.system(size: fontSize1))
                        .foregroundColor(textColor)
                        .padding(10)
                }
            }
            
            VStack (alignment: .leading, spacing: 5) {
                HStack (alignment: .top) {
                    VStack (alignment: .leading) {
                        Image(systemName: "checkmark.square")
                            .font(.system(size: 14))
                    }
                    VStack (alignment: .leading) {
                        Text(message1a)
                            .bold()
                        + Text(llImager)
                            .italic()
                        + Text(message1b)
                        + Text(llImager)
                            .italic()
                        + Text(message1c)
                        + Text(message1d)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(textColor)
                
                HStack (alignment: .top) {
                    VStack  (alignment: .leading)  {
                        Image(systemName: "checkmark.square")
                            .font(.system(size: 14))
                    }
                    VStack (alignment: .leading) {
                        Text(message2a)
                            .bold()
                        + Text(message2b)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(textColor)
                
                HStack (alignment: .top) {
                    VStack  (alignment: .leading)  {
                        Image(systemName: "checkmark.square")
                            .font(.system(size: 14))
                    }
                    VStack (alignment: .leading) {
                        Text(message3a)
                            .bold()
                        + Text(message3b)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(textColor)
                
                HStack (alignment: .top) {
                    VStack  (alignment: .leading)  {
                        Image(systemName: "checkmark.square")
                            .font(.system(size: 14))
                    }
                    VStack (alignment: .leading) {
                        Text(message4a)
                            .bold()
                        + Text(message4b)
                        + Text(llImager)
                            .italic()
                        + Text(message4c)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(textColor)
                HStack (alignment: .top) {
                    VStack  (alignment: .leading)  {
                        Image(systemName: "checkmark.square")
                            .font(.system(size: 14))
                    }
                    VStack (alignment: .leading) {
                        Text(message5a)
                            .bold()
                        + Text(message5b)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(textColor)
                HStack (alignment: .top) {
                    VStack  (alignment: .leading)  {
                        Image(systemName: "checkmark.square")
                            .font(.system(size: 14))
                    }
                    VStack (alignment: .leading) {
                        Text(message6a)
                            .bold()
                        + Text(message6b)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(textColor)
                
                
            }
            .padding(10)
            
            VStack (alignment: .leading) {
                Text("Important Notice on Antivirus Software")
                    .font(.system(size: 14))
            Text("In rare cases 3rd party antivirus may interfer with LL")
            + Text(llImager)
                .italic()
            + Text(". If you encounter issues, temporarily disable the antivirus and reactivate it inmediately after.")
                }
            .font(.system(size: 12))
            .foregroundColor(textColor)
            
            VStack {
                Text("Proceed with caution and thank you for using LL")
                + Text(llImager)
                    .italic()
            }
            .font(.system(size: 16))
            .foregroundColor(textColor)
            .padding(10)
            
            Button("OK") {
                onOK()
            }
            .background(Color("LL_blue"))
            .foregroundColor(.white)
            .padding()
        }
        .frame(width: 527, height: 430)  // )
        .background(backgroundColor)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
//    @State private var showAlert = true
    CustomAlertView0 {
        
    }
}

