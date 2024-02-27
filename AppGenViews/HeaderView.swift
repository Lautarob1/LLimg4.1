//
//  HeaderView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/26/23.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            Image("LLimager_Window2")
                .resizable()
                .frame(width: 900, height: 60)
                .scaledToFit()

            // Alignment of the text
            HStack (spacing: 50) {
//                Spacer() // Pushes the text to the right
                VStack {
                    Spacer() // Pushes the text to the bottom
                    Text("Version 4.0")
                        .font(.headline)
                        .foregroundColor(.black) // Change the color if needed
//                        .padding([.bottom, .trailing], 20) // Adjust padding
                        .frame(width: 300, alignment: .leading) // Set the frame width wider than the text
                        .position(x: 430 + 150, y: 30)
                }
            }
        }
        .frame(width: 900, height: 60)
    }
}

#Preview {
    HeaderView()
}
