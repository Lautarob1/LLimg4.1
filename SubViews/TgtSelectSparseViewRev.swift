//
//  TgtSelectFFView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/29/24.
//

import SwiftUI

struct TgtSelectSparseViewRev: View {
    @State private var filePath: String = ""
    @ObservedObject private var fileSelectionManager = FileSelectionManager()
    let path2img: String = "Enter path"
    let butlabel: String = "Choose File"
    
    var body: some View {
ScrollView {
            VStack {
                HStack {
                 Text("Sparse to be Converted")
                .font(.headline)
                .padding(.vertical, 5)
     
                }
                .background(Color.clear)
                
                List {
                    ForEach(FileSelectionManager.shared.selectedFiles) { file in
                        HStack {
                            Text(file.path)
                                .font(.caption)
                            Spacer()
                            Text("\(file.size) bytes")
                                .font(.caption)
                        }
                    }
                    Spacer()
                    HStack {
                          Text("Total Size")
                            .font(.caption)
                          Spacer()
                          Text("\(FileSelectionManager.shared.totalSize) bytes")
                            .font(.caption)
                      }
                }

            }
            .frame(width: 430, height: 300)
        }
    }
    
 
}

#Preview {
    TgtSelectSparseViewRev()
}
