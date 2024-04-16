//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct ImgInfoSparseView: View {
    @ObservedObject private var diskDataManager = DiskDataManager.shared
    @ObservedObject private var caseInfoData = CaseInfoData.shared
    @State private var imageName: String = CaseInfoData.shared.imageName
    @State private var selectedDskOption: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isInputValid: Bool = true
    @State private var isChecked: Bool = true
    
    var body: some View {
        VStack {
            Text("Convert Sparse to DMG")
                .font(.title)
                .foregroundColor(Color("LL_blue"))
            HStack {
                Text("Image Name:")
                    .font(.headline)
                    .padding(.leading, 3)
                TextField("Enter image name", text: $imageName, onCommit: {
                    isInputValid = validateInput(name: imageName)
                })
                .border(isInputValid ? Color.clear : Color.red)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: imageName) { newValue in
                    // Update the singleton when the local state changes
                    CaseInfoData.shared.imageName = newValue
                }
                
            }
            HStack {
                TgtSelectSparseView()
            }
            HStack {
                FilePickerView(path2img: "DESTINATION path", butlabel: "Select..." ) { selectedPath in
                    DiskDataManager.shared.selectedStorageDestin = selectedPath}
            }
                
                VStack (alignment: .leading)
                {
                    Text("Hash file")
                        .padding(.leading, 10)
                    OptionButtonsView()
                }
                .padding()
                .background(Color.clear)
                // if

        }
        .frame(width: 420, height: 500)
        .padding()
        
        
    }
    
}

#Preview {
    ImgInfoSparseView()
}
