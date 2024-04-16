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
//    @ObservedObject var validModel: ValidationViewModel
    @State private var imageName: String = "AcqImage01"
    @State private var path2img: String = "Select destination path"
//    @State private var path2img: String = "/Volumes/llidata"
    @State private var selectedDskOption: String = ""
    @State private var selectedPath2img: String = ""
    @State private var alertMsgName: String = ""
    @State private var alertMsgPath: String = ""
    @State private var titleMsgName: String = ""
    @State private var titleMsgPath: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isChecked: Bool = true
    @State private var isInputValid: Bool = true
    @State private var isPathValid: Bool = true
//    @FocusState private var nameFieldIsFocused: Bool
    @State private var showCustomAlert: Bool = false

    
    var body: some View {
            VStack {
                Text("Image Information")
                .font(.title)
                .foregroundColor(Color("LL_blue"))
                ZStack {
                    VStack {
                        if #available(macOS 12.0, *) {
                            TextField("Enter image name", text: $imageName)
//                                .focused($nameFieldIsFocused)
                                .border(isInputValid ? Color.clear : Color.red)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            // Fallback on earlier versions
                            TextField("Enter image name", text: $imageName)
//                                .focused($nameFieldIsFocused)
                                .border(isInputValid ? Color.clear : Color.red)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                    HStack {
                        ComboBoxView(
                            selectedDskOption: Binding(
                                get: { DiskDataManager.shared.selectedDskOrigen },
                                set: { DiskDataManager.shared.selectedDskOrigen = $0 }
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
                        FilePickerView(path2img: path2img, butlabel: "Select..." ) { selectedPath in
                            DiskDataManager.shared.selectedStorageDestin = selectedPath}
                                            }
            
                        // Other UI elements
                    }

                    if showCustomAlert {
                        CustomAlertView2(
                            showAlert2: $showCustomAlert,
                            imageName: "exclamationmark.triangle",
                            title: "🤔 Invalid \(titleMsgName)  \(titleMsgPath)",
                            message: " \(alertMsgName)\n \(alertMsgPath)",
                            fontSize1: 20,
                            fontSize2: 14,
                            textColor: Color(.white),
                            backgroundColor: Color("LL_orange"),
                            onDismiss: {
//                                    nameFieldIsFocused = true
                                    })
                        .offset(y: -100.0)
                    }
                }
                .onChange(of: imageName) { newValue in
                        isInputValid = validateInput(name: newValue)
                        if isInputValid {
                            CaseInfoData.shared.imageName = newValue
                        } else {
                            titleMsgName = "Name"
                            alertMsgName = "Cannot be empty or contain special chars"
                            showCustomAlert = true
                            CaseInfoData.shared.imageName = ""
                        }
                    }
 
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
                .padding(.bottom, 15)
                if caseInfoData.isdmgEnabled {
                    HStack {
                        FilePickerWithCheckView(path2img: "Diff path to DMG", butlabel: "Select...", enablefb: "Uncheck to choose a different path for final image")  { selectedPath in
                            DiskDataManager.shared.selected2ndStorageDestin = selectedPath}

                    }
//                    .padding()
                    
                    VStack (alignment: .leading)
                    {
                        Text("Hash file")
                            .padding(.leading, 10)
                        OptionButtonsView()
                    }
                    .padding()
                    .background(Color.clear)
                } // if
            }
                .frame(width: 420) //, height: 600)
                .padding()
            }


}

//#Preview {
//    if #available(macOS 12.0, *) {
//        ImgInfoView1()
//    } else {
//        // Fallback on earlier versions
//    }
//                  
//}
