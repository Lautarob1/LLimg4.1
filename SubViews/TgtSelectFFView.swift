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

            .background(Color.clear)

//            ScrollView {
                List(selection: $selectedItems) {
                    ForEach(FileSelectionManager.shared.selectedFiFo, id: \.id) { file in
                        HStack {
                            Text(file.path)
                                .font(.subheadline)
 
                        }
                    }

                }
//            }


            HStack {
                Button("Delete Selected") {
                    deleteSelectedItems()
                }

                
            }
            
        }
        .frame(width: 420, height: 220)
    }
    
    
    func deleteSelectedItems() {
        FileSelectionManager.shared.selectedFiFo.removeAll { fileItem in
            selectedItems.contains(fileItem.id)
        }
        selectedItems.removeAll()
    }
}


#Preview {
    TgtSelectFFView()
}
