//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct ImgInfoHashView: View {
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
                Text("Hash DMG or other files")
                .font(.title)
                .foregroundColor(Color("LL_blue"))
                HStack {
                    Text("File Name for hash report:")
                        .font(.headline)
                        .padding(.leading, 3)
                    TextField("Enter name for hash report", text: $imageName, onCommit: {
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
                   TgtSelect4HashView()
                }
                HStack {
                    FilePickerView(path2img: "Destination for report", butlabel: "Select..." ) { selectedPath in
                        DiskDataManager.shared.selectedStorageDestin = selectedPath}
                                        }
  

    
              
                    
                    VStack (alignment: .leading)
                    {
                        Text("Hash file")
                            .padding(.leading, 10)
                        OptionButtonsView2()
                    }
                    .padding()
                    .background(Color.clear)
                // if
            }
                .frame(width: 420)
                .padding()
            }

    
        }



#Preview {
    ImgInfoHashView()
}
