//
//  FilePickerView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI
import AppKit

struct FilePickerView: View {
    @State private var filePath: String = ""
    let path2img: String
    let butlabel: String
    var onPathSelected: (String) -> Void
    
    var body: some View {
        HStack {
            TextField(path2img, text: $filePath)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 310, alignment: .leading)
                .padding()

            Button(butlabel) {
                let openPanel = NSOpenPanel()
                openPanel.allowsMultipleSelection = false
                openPanel.canChooseDirectories = true
                openPanel.canChooseFiles = false

                if openPanel.runModal() == .OK {
                    self.filePath = openPanel.url?.path ?? ""
                    onPathSelected(self.filePath) 
                }
            }
        }
        .frame(width: 420)
        .background()
    }
}


#Preview {
//    FilePickerView(butlabel: "Browse...")
    FilePickerView(path2img: "path", butlabel: "Browse...") { selectedPath in
        CaseInfoData.shared.imgfilePath = selectedPath}
}
