//
//  TestTableFilesView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/18/24.
//

import SwiftUI

struct TestTableFilesView: View {
    
    @State private var filePath: String = ""
    @ObservedObject private var fileSelectionManager = FileSelectionManager()
    let path2img: String = "Enter path"
    let butlabel: String = "Choose File"
    
    var body: some View {
        VStack {
            HStack {
                TextField(path2img, text: $filePath)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 275, alignment: .leading)
                    .padding()
                
                Button(butlabel) {
                    let openPanel = NSOpenPanel()
                    openPanel.allowsMultipleSelection = true
                    openPanel.canChooseDirectories = true
                    openPanel.canChooseFiles = true
                    
                    if openPanel.runModal() == .OK {
                        openPanel.urls.forEach { url in
                            fileSelectionManager.addFile(path: url.path)
                        }
                    }
                }
            }
            .background()
        
            List {
                ForEach(fileSelectionManager.selectedFiles) { file in
                    HStack {
                        Text(file.path)
                        Spacer()
                        Text("\(file.size) bytes")
                    }
                }
                .onDelete(perform: deleteItems)
        
                HStack {
                      Text("Total Size")
                      Spacer()
                      Text("\(fileSelectionManager.totalSize) bytes")
                  }
                .padding(.vertical, 50)
            }
            
            Button("OK") {
                let selectedPaths = fileSelectionManager.selectedFiles.map { $0.path }
                // Process selectedPaths array
                print(selectedPaths)
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        fileSelectionManager.selectedFiles.remove(atOffsets: offsets)
    }
    
}

#Preview {
    TestTableFilesView()
}
