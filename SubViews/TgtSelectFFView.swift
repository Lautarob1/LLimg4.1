//
//  TgtSelectFFView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/29/24.
//

import SwiftUI

struct TgtSelectFFView: View {
    @State private var filePath: String = ""
    @State private var selectedItems = Set<UUID>()
    @ObservedObject private var fileSelectionManager = FileSelectionManager()
    @State private var stillWorking = false
    let path2img: String = "Targeted files or folders"
    
    var body: some View {
        VStack {
            HStack {
                TextField(path2img, text: $filePath)
                    .font(.system(size: 12))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(width: 290, alignment: .leading)
                    .padding(2)
                
                Button(action: {
                    let openPanel = NSOpenPanel()
                    openPanel.allowsMultipleSelection = true
                    openPanel.canChooseDirectories = true
                    openPanel.canChooseFiles = true
                    
                    if openPanel.runModal() == .OK {
//                        stillWorking = true
                        openPanel.urls.forEach { url in
                            fileSelectionManager.addFileFolder(path: url.path)
                            FileSelectionManager.shared.addFileFolder(path: url.path)
//                        stillWorking = false
                        }
                    }
                    
                })
                {
                    Text("Select Files/Folders")

                    
                      
                }

            }

            .background()


            List(selection: $selectedItems) {
                ForEach(FileSelectionManager.shared.selectedFiFo, id: \.id) { file in
                    HStack {
                        Text(file.path)
                            .font(.subheadline)
//                        Spacer()
//                        Text("\(file.size) bytes")
//                            .font(.caption)
                    }
                }
//                HStack {
//                    Text("Total Size")
//                        .font(.caption)
//                    Spacer()
//                    Text("\(FileSelectionManager.shared.totalSize) bytes")
//                        .font(.caption)
//                }
    }
//    .listStyle(SidebarListStyle())

            HStack {
                Button("Delete Selected") {
                    deleteSelectedItems()
                }

                
            }
            
        }
        .frame(width: 420, height: 220)
    }
    
    private func selectFilesAndFolders() {
        print("in select files/flds with stillWorking= \(stillWorking)")
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = true

        if openPanel.runModal() == .OK {
            stillWorking = true // Set processing to true
            let selectedURLs = openPanel.urls
            DispatchQueue.main.async {
            self.stillWorking = true // Ensure this is set on the main thread
                        }
            DispatchQueue.global(qos: .userInitiated).async {
                for url in selectedURLs {
                    DispatchQueue.main.async {
                        print("in select files/flds with stillWorking= \(stillWorking)")
                        fileSelectionManager.addFile(path: url.path)
                        FileSelectionManager.shared.addFile(path: url.path)
                    }
                }
                DispatchQueue.main.async {
                    self.stillWorking = false // Set processing to false when done
                }
            }
        }
    }
    
    
    func deleteSelectedItems() {
        FileSelectionManager.shared.selectedFiles.removeAll { fileItem in
            selectedItems.contains(fileItem.id)
        }
        selectedItems.removeAll()
    }
}


#Preview {
    TgtSelectFFView()
}
