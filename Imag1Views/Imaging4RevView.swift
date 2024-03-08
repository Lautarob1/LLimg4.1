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
//    @State private var destinationDisk: String
    var onProcess: () -> Void
    var onModify: () -> Void
    var onCancel: () -> Void
    
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
                        
                        ImgInfoViewRev()
//                        HardinfoViewRev()
                    }
                    .padding(.trailing, 25)
                    VStack (spacing: 50){
                        TgtSelect4HashViewRev()
                        VStack (alignment: .leading){
                        Text("Log file will be in:")
                        Text(DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info")
                        
                        }
                
                    }
 
                }
                
                HStack {
                    Button(action: {
                        onCancel()
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
                        onProcess()
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
                        onModify()
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
            }

                }
            }
//        onAppear() {
//            print("on appear with value \(DiskDataManager.shared.selectedStorageOption)")
//            pathforhashlog()          
//        }
 
        }

    func pathforhashlog() {
        print("in func path4log")
        if DiskDataManager.shared.selectedStorageOption == "" {
            DiskDataManager.shared.selectedStorageOption = "/Volumes/llimager/lldata"
        }
    }
            
    }

#Preview {
    Imaging4RevView(onProcess: {}, onModify: {}, onCancel: {}
    )
}
