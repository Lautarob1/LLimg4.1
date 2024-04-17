//
//  FilePickerView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI
import AppKit

struct FilePickerWithCheckView: View {
    @ObservedObject private var caseInfoData = CaseInfoData.shared
        @State private var filePath: String = ""
        @State private var isButtonDisabled: Bool = true
        @State var path2img: String
        let butlabel: String
        let enablefb: String
        var onPathSelected: (String) -> Void
        
        var body: some View {
            VStack {
                HStack {
                    Toggle(enablefb, isOn: $isButtonDisabled)
                        .padding(.leading, 10)
                    Spacer()
                }
                HStack {
                    Text("Path:")
                        .padding(.leading, 3)
                    Text(path2img) //, text: $filePath)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 260, alignment: .leading)
                        .padding()
                Button(butlabel) {
                        let openPanel = NSOpenPanel()
                        openPanel.allowsMultipleSelection = false
                        openPanel.canChooseDirectories = true
                        openPanel.canChooseFiles = false

                        if openPanel.runModal() == .OK {
                            self.filePath = openPanel.url?.path ?? ""
                            onPathSelected(self.filePath)
                            path2img = self.filePath
                        }
                    }
                    .disabled(isButtonDisabled)
                }
                // Checkbox (Toggle)

                
            }
//            .frame(width: 410)
            .background(Color.clear)
        }
}

//
//#Preview {
//    FilePickerWithCheckView(path2img: "path", butlabel: "Browse...", enablefb: "Enable browser")
//}
