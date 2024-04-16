//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct ImgInfoTgtView: View {
    @ObservedObject private var diskDataManager = DiskDataManager.shared
    @ObservedObject private var caseInfoData = CaseInfoData.shared
    @State private var imageName: String = ""
    @State private var selectedDskOption: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isInputValid: Bool = true
    @State private var isChecked: Bool = true
    @FocusState private var nameFieldIsFocused: Bool
    @State private var showCustomAlert: Bool = false
    
    var body: some View {
        
        VStack {

            VStack {
                Text("Target files Information")
                    .font(.title)
                    .foregroundColor(Color("LL_blue"))
                ZStack {
                    VStack {
                        TextField("Enter image name", text: $imageName)
                            .focused($nameFieldIsFocused)
                            .border(isInputValid ? Color.clear : Color.red)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TgtSelectFFView()
                        }
                        HStack {
                            FilePickerView(path2img: "DESTINATION path", butlabel: "Select..." ) { selectedPath in
                                DiskDataManager.shared.selectedStorageDestin = selectedPath}
                        }  // Other UI elements
                    }
                    
                    if showCustomAlert {
                        CustomAlertView2(
                            showAlert2: $showCustomAlert,
                            imageName: "exclamationmark.triangle",
                            title: "Error",
                            message: " 🤔 Invalid image name! (It's blank or contains invalid chars)",
                            fontSize1: 18,
                            fontSize2: 11,
                            textColor: Color(.white),
                            backgroundColor: Color("LL_orange"),
                            onDismiss: {
                                nameFieldIsFocused = true
                            })
                        .offset(y: -180.0)
                    }
                }
                .onChange(of: imageName) { newValue in
                        isInputValid = validateInput(name: newValue)
                        if isInputValid {
                            CaseInfoData.shared.imageName = newValue
                        } else {
                            showCustomAlert = true
                            CaseInfoData.shared.imageName = "Image01"
                        }
                    }
                
                VStack (alignment: .leading)
                {
                    Text("Hash file")
                        .padding(.leading, 10)
                    OptionButtonsView()
                }
                .padding()
                .background()
                // if
                
                
            }
            .frame(width: 420) //, height: 300)
            .padding()
        }
        
    }
    
}


//#Preview {
//    if #available(macOS 12.0, *) {
//        ImgInfoTgtView()
//    } else {
//        // Fallback on earlier versions
//    }
//}
