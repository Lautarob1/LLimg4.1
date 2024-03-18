//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging4View: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
    @Binding var selectedOption: MenuOption?
    @State private var showReviewView = false

    
    var body: some View {
        
        HStack {
            
            VStack {
                HStack(alignment: .top) {
                    Image("img_but4")
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
                ImgInfoHashView()
                HStack {
                    Button(action: {
                        showReviewView = true
                    }) {
                        Text("Review")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 20)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(7)
                            .padding(3)
                    }
                    .sheet(isPresented: $showReviewView) {
                        Imaging4RevView(selectedOption: $selectedOption, showReviewView: $showReviewView)
                    }
                        Button(action: {
                            initHash()
                            self.selectedOption = nil
                        }) {
                            Text("Cancel")
                                .font(.custom("Helvetica Neue", size: 14))
                                .frame(width: 100, height: 20)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(7)
                                .padding(3)
                    }
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            .frame(width: 450, height: 600)
            .padding()
        }
        .onAppear() {
            initHash()
        }
    }
}

struct Imaging4View_Previews: PreviewProvider {
    @State static var selectedOption: MenuOption? = MenuOption(id: 4)
    @State static var showReviewView: Bool = true
    
    static var previews: some View {
        Imaging4RevView(selectedOption: $selectedOption, showReviewView: $showReviewView)
    }
}
    
    
//    
//#Preview {
//    Imaging4View(onReview: {}, onCancel: {}) //.environmentObject(CaseInfoData())
//}
