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
    @State private var showAlertSps: Bool = false
    @State private var disableBCreateImg: Bool = false
    @State private var createImage: Bool = false
    @State private var dupName: Bool = false
    @State private var alertText0: String = ""
    @State private var alertText1: String = ""
    @State private var alertText2: String = ""
    @State private var alertText3: String = ""
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
                            initSparse()
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
                                .foregroundColor(disableBCreateImg ? Color.gray : Color.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(3)
                        }
                        .disabled(disableBCreateImg)
                        
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
                .onAppear() {
                    let sourceDisk = "/dev/"+(extractusedDisk(from: DiskDataManager.shared.selectedDskOption) ?? "/")
                    let destinationDisk = DiskDataManager.shared.selectedStorageOption
                    if validatePath(path: destinationDisk) {
                        let destDMGDisk = DiskDataManager.shared.selected2ndStorageOption
                        let imgName = validateInput(name: CaseInfoData.shared.imageName)
                        print("scr disk: \(sourceDisk )")
                        print("dst disk: \(destinationDisk)")
                        print("dst2 disk: \(destDMGDisk)")
                        print("name of image: \(CaseInfoData.shared.imageName)")
                        //                        let destfullPathSp = destinationDisk + "/" + CaseInfoData.shared.imageName + ".sparse"
                        //                        dupName = isImageNameAtPath(path: destfullPathSp)
                        let destfullPathDMG = destinationDisk + "/" + CaseInfoData.shared.imageName + ".dmg"
                        dupName = isImageNameAtPath(path: destfullPathDMG)
                        print("valid name?: \(imgName)")
                        let noFFSel =  FileSelectionManager.shared.selectedFiles.first?.path != nil
                        
                        let destNoOK = isDestinationInRoot(path: destinationDisk)
                        alertText0 = (!noFFSel ? "😳 No sparse image selected"  : "")
                        alertText1 = (destNoOK ? "\n😳 Invalid! System disk cannot be used as destination"  : "")
                        alertText2 = (imgName ? "" : "\n🤔 Image Name invalid or empty")
                        alertText3 = (dupName ? "\n🤔 Dest file exists, rename or delete DMG file with name: \(CaseInfoData.shared.imageName)" :  "" )
                        //                        print("alert0: \(alertText0)")
                        //                        print("alert1: \(alertText1)")
                        //                        print("alert2: \(alertText2)")
                        //                        print("alert3: \(alertText3)")
                        imageName = "exclamationmark.triangle"
                        if   destNoOK || !imgName || dupName || !noFFSel {
                            disableBCreateImg = true
                            showAlertSps = true
                        }
                    } // close if validatePath
                    else {
                        alertText1 = "Selected path for destination is empty ot invalid"
                        imageName = "folder.badge.questionmark"
                        disableBCreateImg = true
                        showAlertSps = true
                    }
                }
            }
            // show alert here
            if showAlertSps {
                CustomAlertView(
                    showAlert: $showAlertSps,
                    imageName: imageName,
                    title: "LLIMAGER Alert",
                    message: "\(alertText0) \(alertText1)  \(alertText2) \(alertText3) ",
                    fontSize1: 14,
                    fontSize2: 12,
                    textColor: Color(.white),
                    backgroundColor: Color("LL_blue")
                )
                .frame(width: 300, height: 250)
                .cornerRadius(15)
                .shadow(radius: 10)
                .opacity(showAlertSps ? 1 : 0) // Control visibility
                .animation(.easeInOut, value: showAlertSps)
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
    
    


//#Preview {
//    Imaging3RevView(onProcess: {}, onModify: {}, onCancel: {}
//    )
//}
