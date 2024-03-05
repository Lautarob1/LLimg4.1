//
//  imgInfoViewOld.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/12/24.
//

import SwiftUI

struct ImgInfoView1: View {
    @ObservedObject private var diskDataManager = DiskDataManager.shared
    @ObservedObject private var caseInfoData = CaseInfoData.shared
    @State private var imageName: String = ""
    @State private var selectedDskOption: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isChecked: Bool = true
    @State private var isInputValid: Bool = true
    @FocusState private var nameFieldIsFocused: Bool
    @State private var showCustomAlert: Bool = false

    
    var body: some View {
            VStack {
                Text("Image Information")
                .font(.title)
                .foregroundColor(Color("LL_blue"))
                ZStack {
                    VStack {
                        TextField("Enter image name", text: $imageName)
                        .focused($nameFieldIsFocused)
                        .border(isInputValid ? Color.clear : Color.red)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    HStack {
                        ComboBoxView(
                            selectedDskOption: Binding(
                                get: { DiskDataManager.shared.selectedDskOption },
                                set: { DiskDataManager.shared.selectedDskOption = $0 }
                            ),
                            isComboDisabled: Binding(
                                get: { DiskDataManager.shared.isComboDisabled },
                                set: { DiskDataManager.shared.isComboDisabled = $0 }
                            ),
                            pickerLabel: "Select disk ",
                            toggleLabel: "Live Image"
                        )
                        .environmentObject(DiskDataManager.shared)
                    }
                    HStack {
                        Button("View Storage Devices Info") {
                            isViewPresented = true
                        }
                        .sheet(isPresented: $isViewPresented) {
                            // The view you want to present
                            StorageDevView(isPresented: $isViewPresented)
                        }
                    }
                    HStack {
                        FilePickerView(path2img: "path where image will be stored", butlabel: "Select..." ) { selectedPath in
                            DiskDataManager.shared.selectedStorageOption = selectedPath}
                                            }
            
                        // Other UI elements
                    }

                    if showCustomAlert {
                        CustomAlertView2(
                            showAlert2: $showCustomAlert,
                            imageName: "exclamationmark.triangle",
                            title: "🤔 Invalid name!",
                            message: " (Name is blank or contains invalid chars)",
                            fontSize1: 20,
                            fontSize2: 14,
                            textColor: Color(.white),
                            backgroundColor: Color("LL_orange"),
                            onDismiss: {
                                    nameFieldIsFocused = true
                                    })
                        .offset(y: -140.0)
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
//                .onChange(of: nameFieldIsFocused) { isFocused in
//                    if !isFocused {
//                        isInputValid = validateInput(name: imageName)
//                        showCustomAlert = !isInputValid
//                        if isInputValid {
//                            CaseInfoData.shared.imageName = imageName
//                        }
//                        else {
//                            CaseInfoData.shared.imageName = "Image01"
//                        }
//                    }
//                }               
                HStack {
                    Text("Convert to DMG:")
                        .font(.headline)
                        .padding(.leading, 15)
                    Image(systemName: caseInfoData.isdmgEnabled ? "checkmark.square.fill" : "square")
                        .foregroundColor(caseInfoData.isdmgEnabled ? .blue : .gray)
                        .onTapGesture {
                            self.caseInfoData.isdmgEnabled.toggle()
                        }
                    Text("if checked a DMG will be produced")
                    Spacer()
                }

                if caseInfoData.isdmgEnabled {
                    HStack {
                        FilePickerWithCheckView(path2img: "Diff path to DMG", butlabel: "Select...", enablefb: "Uncheck to choose a different path for final image")  { selectedPath in
                            DiskDataManager.shared.selected2ndStorageOption = selectedPath}

                    }
                    .padding()
                    
                    VStack (alignment: .leading)
                    {
                        Text("Hash file")
                            .padding(.leading, 10)
                        OptionButtonsView()
                    }
                    .padding()
                    .background()
                } // if
            }
                .frame(width: 420, height: 500)
                .padding()
            }


}

#Preview {
    ImgInfoView1()
                  
}
