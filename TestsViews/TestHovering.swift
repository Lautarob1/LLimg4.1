//
//  TestHovering.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/26/23.
//

import SwiftUI

struct HoverTestView: View {
    @State private var isImageHovered = false
    
    var body: some View {
        VStack {
            Text(isImageHovered ? "Image Hovering" : "Image Not Hovering")
                .padding(30)
                .background(isImageHovered ? Color.blue : Color.gray)
            
            ZStack {
                Image("img_but1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125, height: 125)
                
                if isImageHovered {
                    Rectangle()
                        .fill(Color("LL_orange").opacity(0.3))
                        .frame(width: 125, height: 125)
                }
            }
            .contentShape(Rectangle()) // This ensures the hover area covers the whole ZStack
            .onHover { isHovering in
                self.isImageHovered = isHovering
                
            }
            .frame(width: 250, height: 350)
        }
    }
    
}
// Fail when hovering over image
//import SwiftUI
//
//struct HoverTestView: View {
//    @State private var isHovered = false
//
//
//
//    var body: some View {
//        VStack {
//            Text(isHovered ? "Hovering" : "Not Hovering")
//                .padding(30)
//                .background(isHovered ? Color.green : Color.gray)
//                .onHover { ishovering in
//                    self.isHovered = ishovering
//                }
//            Button(action: {
//                // Button action
//            }) {
//                //                Image(buttonImages[index - 1])
//                Image("img_but1")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .background(isHovered ? Color.red : Color.clear) // Added for visibility
//            }
//                    .buttonStyle(PlainButtonStyle())
//                    .onHover { isHovering in
//                        self.isHovered = isHovering
//                    }
//      
//        }
//        .frame(width: 200, height: 300)
//    }
//}

#Preview {
    HoverTestView()
}

