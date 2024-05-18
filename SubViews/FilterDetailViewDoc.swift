//
//  FilterSelectView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 4/27/24.
//

import SwiftUI




struct FilterDetailViewDoc: View {
    @ObservedObject var filterSelection = FilterSelection.shared
    @Binding var applyDocumentFilter: Bool
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color(.darkGray)]),
                                  startPoint: .top,
                                  endPoint: .bottom)

    var body: some View {
    
            VStack (alignment: .leading) {
                if FilterSelection.shared.applyDocumentFilter {
                    
                    
                    Text("Word Processing, text, presentations")
                    ScrollView {
                        VStack (alignment: .leading)  {
                        ForEach(filterSelection.documentTypes, id: \.self) { type in
                            let isSelected = filterSelection.selectedDocumentTypes.contains(type)
                            Toggle(type, isOn: Binding(
                                get: { isSelected },
                                set: { newValue in
                                    if newValue {
                                        filterSelection.selectedDocumentTypes.append(type)
                                        
                                        print("Selected : \(filterSelection.selectedDocumentTypes)")
                                        
                                        print("All : \(filterSelection.selectedDocumentTypes)")
                                        
                                        print("\(type) isSelected (add): \(filterSelection.selectedDocumentTypes)")
                                    }
                                    
                                    else {
                                        filterSelection.selectedDocumentTypes.removeAll(where: { $0 == type })
                                        print("\(type) isSelected (remove): \(filterSelection.selectedDocumentTypes)")
                                    }
                                }
                            ))
                        }
                    } // inner VStack
                        .frame(width: 180)
//                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
//
            }

            HStack {
                Button("Cancel") {
                    filterSelection.applySpreadsheetFilter = false
                }
                .padding(5)
 
               Spacer()
                Button("OK") {
                    filterSelection.isSpreadSheetFilterApplied = true
                    filterSelection.applySpreadsheetFilter = false
                    FilterSelection.shared.selectedDocumentTypes = filterSelection.selectedDocumentTypes
                    FilterSelection.shared.selectedAllTypes.append( contentsOf: filterSelection.selectedDocumentTypes)
                }
            }
            }
            .frame(width: 225, height: 180)
            .padding(5)
            .background(gradient)
            .foregroundColor(.white)
            .cornerRadius(15)
                Spacer()
    }


        
    }
    


//#Preview {
//    let filterSelection = FilterSelection.shared
//           filterSelection.mediaSelected = true
//           filterSelection.mediaType = ["audio", "video", "images"]
//    FilterDetailView(filterSelection: filterSelection)
//}

struct FilterDetailViewDoc_Previews: PreviewProvider {
    static var previews: some View {
        let filterSelection = FilterSelection.shared // Create an instance of FilterSelection
        filterSelection.applyDocumentFilter = true // Simulate media selected
//        filterSelection.selectedDocumentTypes = [".xls*", ".xlt*", ".numbers", ".csv", ".ods*"]
//        filterSelection.mediaTypes = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg"] // Simulate media types
        
        return FilterDetailViewDoc(filterSelection: filterSelection, applyDocumentFilter: .constant(true)) // Pass filterSelection to FilterDetailView
        return FilterDetailViewDoc(filterSelection: filterSelection, applyDocumentFilter: .constant(true)) // Pass filterSelection to FilterDetailView
    }
}
