//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct ImgInfoView: View {
    @ObservedObject private var diskDataManager = DiskDataManager.shared
    @ObservedObject private var caseInfoData = CaseInfoData.shared
    @State private var imageName: String = CaseInfoData.shared.imageName
    @State private var selectedDskOption: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isChecked: Bool = true
    
    var body: some View {
            VStack {
                Text("Image Information")
                .font(.title)
                .foregroundColor(Color("LL_blue"))
                HStack {
                    Text("Image Name:")
                        .font(.headline)
                        .padding(.leading, 3)
                    TextField("Enter image name", text: $imageName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: imageName) { newValue in
                            // Update the singleton when the local state changes
                            CaseInfoData.shared.imageName = newValue
                        }
                
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
                    FilePickerView(path2img: "DESTINATION path", butlabel: "Select..." ) { selectedPath in
                        DiskDataManager.shared.selectedStorageDestin = selectedPath}
                                        }
  

                if caseInfoData.isdmgEnabled {
                    HStack {
                        FilePickerWithCheckView(path2img: "Diff path to DMG", butlabel: "Select...", enablefb: "Uncheck to choose a different path for final image")  { selectedPath in
                            DiskDataManager.shared.selected2ndStorageDestin = selectedPath}

                    }
                    .padding()
                    
                    VStack (alignment: .leading)
                    {
                        Text("Hash file")
                            .padding(.leading, 10)
                        OptionButtonsView()
                    }
                    .padding()
                    // background(Color.clear) is for compat with MacOS 11
                    .background(Color.clear)
                } // if
            }
                .frame(width: 420, height: 500)
                .padding()
            }
//    func comboMoveValues() {
//         CaseInfoData.shared.path2img = 
//    }
    
        }



#Preview {
    ImgInfoView()
}
