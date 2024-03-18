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
    @State private var showAlertHash: Bool = false
    @State private var disableBProcHash: Bool = false
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
                            initHash()
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
                        .disabled(disableBProcHash)
                        
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
                .onAppear() {
                    let destHashReport = DiskDataManager.shared.selectedStorageOption
                    if validatePath(path: destHashReport) {
                        let imgName = validateInput(name: CaseInfoData.shared.imageName)
                        print("dst disk: \(destHashReport)")
                        print("name of image: \(CaseInfoData.shared.imageName)")
                        let destfullPathHash = destHashReport + "/" + CaseInfoData.shared.imageName + ".info"
                        dupName = isImageNameAtPath(path: destfullPathHash)
                        print("valid name?: \(imgName)")
                        let noFFSel =  FileSelectionManager.shared.selectedFiles.first?.path != nil
                        let nofilesSelected = "Nothing selected"
                        print("FileSelMgr: \(String(describing: FileSelectionManager.shared.selectedFiles.first?.path))")
                        let destNoOK = isDestinationInRoot(path: destHashReport)
                        alertText0 = (!noFFSel ? "😳 No files selected"  : "")
                        alertText1 = (destNoOK ? "\n😳 Invalid! System disk cannot be used as destination"  : "")
                        alertText2 = (imgName ? "" : "\n🤔 Report Name invalid or empty")
                        alertText3 = (dupName ? "\n🤔 Report file exists, rename or delete file with path: \(imgName)" :  "" )
                        print("File selected?: \(noFFSel)")
                        print("destNoOk: \(destNoOK)")
                        print("imgName: \(imgName)")
                        print("dupName: \(dupName)")
                        imageName = "exclamationmark.triangle"
                        if   destNoOK || !imgName || dupName || !noFFSel {
                            disableBProcHash = true
                            showAlertHash = true
                        }
                    } // close if validatePath
                    else {
                        alertText1 = "Selected path for report destination is empty or invalid"
                        imageName = "folder.badge.questionmark"
                        disableBProcHash = true
                        showAlertHash = true
                    }
                }
            }
            if showAlertHash {
                CustomAlertView(
                    showAlert: $showAlertHash,
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
                .opacity(showAlertHash ? 1 : 0) // Control visibility
                .animation(.easeInOut, value: showAlertHash)
                
            }
            
        }
        .frame(width: 900, height: 700)
    }
     
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
