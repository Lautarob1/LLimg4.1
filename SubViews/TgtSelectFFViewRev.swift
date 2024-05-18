//
//  TgtSelectFFView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/29/24.
//

import SwiftUI

struct TgtSelectFFViewRev: View {
    @State private var filePath: String = ""
    @ObservedObject private var fileSelectionManager = FileSelectionManager()
    let path2img: String = "Enter path"
    let butlabel: String = "Choose File"
    
    var body: some View {

            VStack {
                HStack {
                 Text("S O U R C E")
                .font(.headline)
                .padding(.vertical, 5)
     
                }
                .background(Color.clear)
//                ScrollView {
                    List {
                        ForEach(FileSelectionManager.shared.selectedFiFo) { file in
                            HStack {
                                Text(file.path)
                                    .font(.caption)
                                    .frame(width: 385, height: 16, alignment: .leading)
 
                            }
                        }


                    }


            }
//        }
        .frame(width: 400, height: 200)
    }
    
 
}

#Preview {
    TgtSelectFFViewRev()
}
