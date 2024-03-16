//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging3RevView: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = false
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
//    @State private var showAlertSize: Bool = false
    @Binding var selectedOption: MenuOption?
    @Binding var showReviewView: Bool
    @State private var showProcessView = false
    
    var body: some View {
        
        ZStack {
            HStack {
                
                
                VStack {
                    HStack(alignment: .top) {
                        Image("img_but3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .cornerRadius(15)
                            .padding(.leading)
                        Spacer()  // Pushes the image to the left
                    }
                    
                    
                    HStack {
                        
                        VStack {
                            CaseInfoViewRev()
                            
                            //                        ImgInfoViewRev()
                            //                        HardinfoViewRev()
                        }
                        .padding(.trailing, 25)
                        VStack (spacing: 20){
                            TgtSelectSparseViewRev()
                            TgtInfoViewRev()
                        }
                        
                    }
                    
                    HStack {
                        Button(action: {
                            self.selectedOption = nil
                        }) {
                            Text("Cancel")
                                .font(.custom("Helvetica Neue", size: 14))
                                .frame(width: 100, height: 20)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(3)
                        }
                        
                        Button(action: {
                            self.showProcessView = true
                        }) {
                            Text("Create DMG")
                                .font(.custom("Helvetica Neue", size: 14))
                                .frame(width: 100, height: 20)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(3)
                        }
                        
                        Button(action: {
                            self.showReviewView = false
                        }) {
                            Text("Change values")
                                .font(.custom("Helvetica Neue", size: 14))
                                .frame(width: 100, height: 20)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(3)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 15)
                    .sheet(isPresented: $showProcessView) {
                        Imaging3ProcView(selectedOption: $selectedOption)
                    }
                    
                }
            }
            
        }
        

        
    } 
    
    
    struct Imaging3RevView_Previews: PreviewProvider {
        @State static var selectedOption: MenuOption? = MenuOption(id: 2)
        @State static var showReviewView: Bool = true
        
        static var previews: some View {
            Imaging3RevView(selectedOption: $selectedOption, showReviewView: $showReviewView)
        }
    }
}




//#Preview {
//    Imaging3RevView(onProcess: {}, onModify: {}, onCancel: {}
//    )
//}
