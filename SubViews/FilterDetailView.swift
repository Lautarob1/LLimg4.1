//
//  FilterSelectView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 4/27/24.
//

import SwiftUI




struct FilterDetailView: View {
    @ObservedObject var filterSelection: FilterSelection
    @Binding var isFilterDetailVisible: Bool
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                if FilterSelection.shared.applySpreadsheetFilter {
//                    Section(header: Text("Spreadsheet")) {
                    Text("spreadsheet types")
                        ForEach(filterSelection.spreadSheetTypes, id: \.self) { type in
                            let isSelected = filterSelection.selectedSpreadsheetTypes.contains(type)
                            Toggle(type, isOn: Binding(
                                get: { isSelected },
                                set: { newValue in
                                    if newValue {
                                        filterSelection.selectedSpreadsheetTypes.append(type)
                                        filterSelection.selectedAllTypes.append(type)
                                        print("\(type) isSelected (add): \(isSelected)")
                                    } else {
                                        filterSelection.selectedSpreadsheetTypes.removeAll(where: { $0 == type })
                                        filterSelection.selectedAllTypes.removeAll(where: { $0 == type })
                                        print("\(type) isSelected (remove): \(isSelected)")
                                    }
                                }
                            ))
                        }
                }
                if filterSelection.applyDocumentFilter {
                    Section(header: Text("Document")) {
                        ForEach(filterSelection.mediaTypes, id: \.self) { type in
                            let isSelected = filterSelection.selectedAllTypes.contains(type)
                            Toggle(type, isOn: Binding(
                                get: { isSelected },
                                set: { newValue in
                                    if newValue {
                                        filterSelection.selectedAllTypes.append(type)
                                    } else {
                                        filterSelection.selectedAllTypes.removeAll(where: { $0 == type })
                                    }
                                }
                            ))
                        }
                    }
                }
                
                if filterSelection.applyMediaFilter {
                    Section(header: Text("Media")) {
                        ForEach(filterSelection.spreadSheetTypes, id: \.self) { type in
                            let isSelected = filterSelection.selectedAllTypes.contains(type)
                            Toggle(type, isOn: Binding(
                                get: { isSelected },
                                set: { newValue in
                                    if newValue {
                                        filterSelection.selectedAllTypes.append(type)
                                    } else {
                                        filterSelection.selectedAllTypes.removeAll(where: { $0 == type })
                                    }
                                }
                            ))
                        }
                    }
                }
            }
            .frame(width: 200)
            Spacer()
            HStack {
                Button("Cancel") {
                    print("button cancel pressed")
                    print(" cancel in FDV applyfiler  \(filterSelection.applySpreadsheetFilter)")
                    print(" cancel in FDV shared applyfiler  \(FilterSelection.shared.applySpreadsheetFilter)")
                    
                    self.isFilterDetailVisible = false
                }
                .padding()
                
                //                Spacer(maxLength: 10)
                
                Button("OK") {
                    print("button OK pressed")
                    print(" OK in FDV applyfiler  \(filterSelection.applySpreadsheetFilter)")
                    print(" OK in FDV types \(filterSelection.spreadSheetTypes)")
                    
                    print(" OK in FDV shared applyfiler  \(FilterSelection.shared.applySpreadsheetFilter)")
                    self.isFilterDetailVisible = false
                }
            }
        }
            .frame(width: 200, height: 200)
            .padding()
            .background(Color("LL_orange"))
            .foregroundColor(.white)

    }
}

//#Preview {
//    let filterSelection = FilterSelection.shared
//           filterSelection.mediaSelected = true
//           filterSelection.mediaType = ["audio", "video", "images"]
//    FilterDetailView(filterSelection: filterSelection)
//}

struct FilterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let filterSelection = FilterSelection.shared // Create an instance of FilterSelection
        filterSelection.isMediaFilterApplied = true // Simulate media selected
        filterSelection.mediaTypes = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg"] // Simulate media types
        
        return FilterDetailView(filterSelection: filterSelection, isFilterDetailVisible: .constant(true)) // Pass filterSelection to FilterDetailView
    }
}
