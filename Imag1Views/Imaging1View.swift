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
    @Binding var selectedOption: MenuOption?
    @State private var showReviewView = false

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
            .background(Color.clear)
            VStack {
                ImgInfoView1()
                
                HStack {
                    Button(action: {
                       print("Img name: \(CaseInfoData.shared.imageName)")
                        showReviewView = true

                    }) {
                        Text("Review")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(5)
                    }
                    
                    .sheet(isPresented: $showReviewView) {
                        Imaging1RevView(selectedOption: $selectedOption, showReviewView: $showReviewView)
                    }
                    Button(action: {
                        self.selectedOption = nil
                    }) {
                        Text("Cancel")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(5)
                    }
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: 450, height: 600)
            .padding()
            
        }
    }
    
    
    
}

struct Imaging1View_Previews: PreviewProvider {
    @State static var selectedOption: MenuOption? = MenuOption(id: 1)
    
    static var previews: some View {
        Imaging1View(selectedOption: $selectedOption)
    }
}


//#Preview {
//    @State var selectedOption: MenuOption? = MenuOption(id: 1)
//    Imaging1View (selectedOption: $selectedOption)
//}
