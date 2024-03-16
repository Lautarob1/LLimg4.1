//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging2View: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
//    var onReview: () -> Void
//    var onCancel: () -> Void
    @Binding var selectedOption: MenuOption?
    @State private var showReviewView = false
    
    var body: some View {

        HStack {
            
            VStack {
                HStack(alignment: .top) {
                        Image("img_but2")
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
                    .fill(Color("LL_blue").opacity(0.3))
                
                // only as separator of VStacks
            }
            .frame(width: 20, height: 500)
            .padding(7)
            .background()
            VStack {
                ImgInfoTgtView()
           
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
                    Imaging2RevView(selectedOption: $selectedOption, showReviewView: $showReviewView)
                }
                Button(action: {
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
                }
                .padding()
            }
                .frame(width: 450, height: 600)
                .padding()

        }
        }

}

struct Imaging2View_Previews: PreviewProvider {
    @State static var selectedOption: MenuOption? = MenuOption(id: 1)
    
    static var previews: some View {
        Imaging2View(selectedOption: $selectedOption)
    }
}


//#Preview {
//    Imaging2View(onReview: {}, onCancel: {}) //.environmentObject(CaseInfoData())
//}
