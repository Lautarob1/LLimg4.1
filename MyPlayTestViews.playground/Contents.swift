//: A Cocoa based Playground to present user interface

import SwiftUI
import AppKit

struct FilePickerView: View {
    @State private var filePath: String = ""
//    @State private var isButtonDisabled: Bool = true
    @State private var path2img: String = "" //CaseInfoData.shared.path2img
//    let path2img: String
    let butlabel: String
    
    var body: some View {
        HStack {
            TextField(path2img, text: $filePath)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(butlabel) {
                let openPanel = NSOpenPanel()
                openPanel.allowsMultipleSelection = false
                openPanel.canChooseDirectories = true
                openPanel.canChooseFiles = true

                if openPanel.runModal() == .OK {
                    self.filePath = openPanel.url?.path ?? ""
                }
            }
        }
    }
}


#Preview {
    FilePickerView(butlabel: "Browse...")
//    FilePickerView(path2img: "path", butlabel: "Browse...")
}
