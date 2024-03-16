//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct ImgConvSparseView: View {
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
            Text("Sparse to DMG information")
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
                            DiskDataManager.shared.selectedStorageOption = selectedPath}
                    }  // Other UI elements
                }
                
                if showCustomAlert {
                    CustomAlertView2(
                        showAlert2: $showCustomAlert,
                        imageName: "exclamationmark.triangle",
                        title: "Error",
                        message: " 🤔 Invalid name! (It's blank or contains invalid chars)",
                        fontSize1: 18,
                        fontSize2: 12,
                        textColor: Color(.white),
                        backgroundColor: Color("LL_orange"),
                        onDismiss: {
                            nameFieldIsFocused = true
                        })
                    .offset(y: -150.0)
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
            VStack {
                //        Text("Target files Information")
                //            .font(.title)
                //            .foregroundColor(Color("LL_blue"))
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
                                DiskDataManager.shared.selectedStorageOption = selectedPath}
                        }  // Other UI elements
                    }
                    
                    if showCustomAlert {
                        CustomAlertView2(
                            showAlert2: $showCustomAlert,
                            imageName: "exclamationmark.triangle",
                            title: "Error",
                            message: " 🤔 Invalid name! (It's blank or contains invalid chars)",
                            fontSize1: 18,
                            fontSize2: 12,
                            textColor: Color(.white),
                            backgroundColor: Color("LL_orange"),
                            onDismiss: {
                                nameFieldIsFocused = true
                            })
                        .offset(y: -150.0)
                    }
                }
                .onChange(of: nameFieldIsFocused) { isFocused in
                    if !isFocused {
                        isInputValid = validateInput(name: imageName)
                        showCustomAlert = !isInputValid
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
            .frame(width: 420, height: 500)
            .padding()
        }
        
    }
    
}


#Preview {
    ImgInfoTgtView()
}
