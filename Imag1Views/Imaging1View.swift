//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging1View: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
    //    @State private var isInputValid: Bool = true
    //    @State private var showCustomAlert: Bool = false
    var onReview: () -> Void
    var onCancel: () -> Void
    
//    @available(macOS 14.0, *)
//    @available(macOS 14.0, *)
    var body: some View {
        
        HStack {
            
            VStack {
                HStack(alignment: .top) {
                    Image("img_but1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .cornerRadius(15)
                        .padding(.leading)
                    Spacer()  // Pushes the image to the left
                }
                
                CaseInfoView()
                    .padding(.leading, 10)
                
            }
            .frame(width: 360, height: 500)
            VStack{
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color("LL_blue")).opacity(0.3)
                
                // only as separator of VStacks
            }
            .frame(width: 20, height: 500)
            .padding(7)
            .background()
            VStack {
                ImgInfoView1()
                
                HStack {
                    Button(action: {
                       print("Img name: \(CaseInfoData.shared.imageName)")
                            onReview()
                        
                    }) {
                        Text("Review")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(5)
                    }
                    Button(action: {
                        onCancel()
                    }) {
                        Text("Cancel")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(5)
                    }
                }
                .padding()
            }
            .frame(width: 450, height: 600)
            .padding()
            
        }
    }
    
    
    
}

#Preview {
    Imaging1View(onReview: {}, onCancel: {})
}
