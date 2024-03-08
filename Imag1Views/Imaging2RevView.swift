//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging2RevView: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = false
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
    @State private var showAlertSize: Bool = false
    @State private var createImage: Bool = false
    @State private var alertText1: String = ""
    @State private var alertText2: String = ""
//    @State private var destinationDisk: String
    var onProcess: () -> Void
    var onModify: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        
        ZStack {
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
                
                
                HStack {
                    
                    VStack {
                        CaseInfoViewRev()
                        
//                        ImgInfoViewRev()
                        HardinfoViewRev()
                    }
                    .padding(.trailing, 25)
                    VStack (spacing: 20){
                        TgtSelectFFViewRev()
                        TgtInfoViewRev()
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
                        Text("Create Image")
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
            .onAppear() {
                let sourceDisk = "/dev/"+(extractusedDisk(from: DiskDataManager.shared.selectedDskOption) ?? "/")
                let destinationDisk = DiskDataManager.shared.selectedStorageOption
                let destDMGDisk = DiskDataManager.shared.selected2ndStorageOption
                let imgName = validateInput(name: CaseInfoData.shared.imageName)
                print("scr disk: \(sourceDisk )")
                print("dst disk: \(destinationDisk)")
                print("dst2 disk: \(destDMGDisk)")
                print("name of image: \(CaseInfoData.shared.imageName)")
                print("valid name?: \(imgName)")
                let sizeNoOK = !isStorageSizeOK2 (sourceDisk: sourceDisk , destinationDisk: destinationDisk, destDMGDisk: destDMGDisk)
                alertText1 = (sizeNoOK ? "😯 Not enough space in the destination disk for"  : "")
                alertText2 = (imgName ? "" : "\n😳 Image Name invalid or empty")
                if   sizeNoOK || !imgName {
                    createImage = true
                    showAlertSize = true
                }
            }
                }
            }
 
        }
            
    } // here closes ZStack
        


#Preview {
    Imaging2RevView(onProcess: {}, onModify: {}, onCancel: {}
    )
}
