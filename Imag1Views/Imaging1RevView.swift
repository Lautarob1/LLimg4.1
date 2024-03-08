//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging1RevView: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = false
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
    @State private var showAlertSize: Bool = false
    @State private var disableBCreateImg: Bool = false
    @State private var validStorage: Bool = false
    @State private var dupName: Bool = false
    @State private var alertText1: String = ""
    @State private var alertText2: String = ""
    @State private var alertText3: String = ""
//    @State private var destinationDisk: String
    var onProcess: () -> Void
    var onModify: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        
        ZStack {
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
                
                
                HStack {
                    
                    VStack {
                        CaseInfoViewRev()
                        
                        ImgInfoViewRev()
                        HardinfoViewRev()
                    }
                    .padding(.trailing, 30)
                    DiskinfoViewRev()
                    
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
                            .foregroundColor(disableBCreateImg ? Color.gray : Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(3)
                    }
                    .disabled(disableBCreateImg)
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
                            .border(Color.clear)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 15)
            }
            .onAppear() {
                let sourceDisk = "/dev/"+(extractusedDisk(from: DiskDataManager.shared.selectedDskOption) ?? "/")
                let destinationDisk = DiskDataManager.shared.selectedStorageOption
                if validatePath(path: destinationDisk) {
                let destDMGDisk = DiskDataManager.shared.selected2ndStorageOption
                let imgName = validateInput(name: CaseInfoData.shared.imageName)
                let destfullPathSp = destinationDisk + "/" + CaseInfoData.shared.imageName + ".sparseimage"
                    dupName = isImageNameAtPath(path: destfullPathSp)
                    
                let destfullPathDMG = destinationDisk + "/" + CaseInfoData.shared.imageName + ".sparseimage"
                    dupName = isImageNameAtPath(path: destfullPathDMG)
                    
                print("scr disk: \(sourceDisk )")
                print("dst disk: \(destinationDisk)")
                print("dst2 disk: \(destDMGDisk)")
                print("name of image: \(CaseInfoData.shared.imageName)")
                print("valid name?: \(imgName)")
                print("dupName?: \(dupName)")
                    
                let sizeNoOK = !isStorageSizeOK2 (sourceDisk: sourceDisk , destinationDisk: destinationDisk, destDMGDisk: destDMGDisk)
                alertText1 = (sizeNoOK ? "😯 Not enough space in the destination disk for the selected source path"  : "")
                alertText2 = (imgName ? "" : "\n😳 Image Name invalid or empty")
                alertText3 = (dupName ? "\n🤔 Dest file exists, rename or delete sparse or DMG files with name: \(imgName)" :  "" )
                imageName = "exclamationmark.triangle"
                    if   sizeNoOK || !imgName || dupName {
                        disableBCreateImg = true
                        showAlertSize = true
                    }
                }
                else {
                    alertText1 = "Selected path for destination is empty ot invalid"
                    imageName = "folder.badge.questionmark"
                    disableBCreateImg = true
                    showAlertSize = true
                }
            }
 
        }
        // show alert here
            if showAlertSize {
                CustomAlertView(
                    showAlert: $showAlertSize,
                    imageName: imageName,
                    title: "LLIMAGER Alert",
                    message: "\(alertText1)  \(alertText2) \(alertText3) ",
                    fontSize1: 14,
                    fontSize2: 12,
                    textColor: Color(.white),
                    backgroundColor: Color("LL_blue")
                )
                .frame(width: 300, height: 250)
                .cornerRadius(15)
                .shadow(radius: 10)
                .opacity(showAlertSize ? 1 : 0) // Control visibility
                .animation(.easeInOut, value: showAlertSize)
             
            }
            
    } // here closes ZStack
        
    }

}

#Preview {
    Imaging1RevView(onProcess: {}, onModify: {}, onCancel: {}
    )
}
