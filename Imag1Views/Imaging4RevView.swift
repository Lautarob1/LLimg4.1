//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging4RevView: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = false
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
    @State private var showAlertSize: Bool = false
    @Binding var selectedOption: MenuOption?
    @Binding var showReviewView: Bool
    @State private var showProcessView = false
    
    var body: some View {
        
        ZStack {
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
                    
                    
                    HStack {
                        
                        VStack {
                            CaseInfoViewRev()
                            
//                            ImgInfoViewRev()
                        }
                        .padding(.trailing, 25)
                        VStack (spacing: 30){
                            TgtSelect4HashViewRev()
                            VStack (alignment: .leading){
                                Text("Log file will be in: \n")
                                Text(DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info")
                                
                            }
                            
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
                            Text("Process Hash")
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
                        Imaging4ProcView(selectedOption: $selectedOption)
                    }
                    
                }
            }
            
        }
    }

//    func pathforhashlog() {
//        print("in func path4log")
//        if DiskDataManager.shared.selectedStorageOption == "" {
//            DiskDataManager.shared.selectedStorageOption = "/Volumes/llimager/lldata"
//        }
//    }
            
    }

struct Imaging4RevView_Previews: PreviewProvider {
        @State static var selectedOption: MenuOption? = MenuOption(id: 4)
        @State static var showReviewView: Bool = true
        
        static var previews: some View {
            Imaging4RevView(selectedOption: $selectedOption, showReviewView: $showReviewView)
        }
    }

//#Preview {
//    Imaging4RevView(selectedOption: selectedOption, showReviewView: $showReviewView)
//    )
//}
