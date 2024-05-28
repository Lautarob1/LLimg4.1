//
//  FilterSelectView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 4/27/24.
//

import SwiftUI




struct TestFilterDetailViewSSh: View {
    @ObservedObject var filterSelection = FilterSelection()
    @Binding var applySpreadsheetFilter: Bool
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color(.darkGray)]),
                                  startPoint: .top,
                                  endPoint: .bottom)
    
    var body: some View {
//        ScrollView {
        VStack (alignment: .leading) {
            if filterSelection.applySpreadsheetFilter {
                Text("spreadsheet types")
                    .padding(.leading, 5)
                ScrollView {
                VStack (alignment: .leading) {
//                    HStack (alignment: .top) {
           

                    ForEach(filterSelection.spreadsheetTypes, id: \.self) { type in Toggle(type, isOn: Binding<Bool>(
//                        let isSelected = filterSelection.selectedSpreadsheetTypes.contains(type)
//                       testPrint()
                        get: {filterSelection.selectedSpreadsheetTypes.contains(type)},
                            set: { newValue in
                                if newValue {
                                    if !filterSelection.selectedSpreadsheetTypes.contains(type) {
                                        filterSelection.selectedSpreadsheetTypes.append(type)
                                    }
                                    print("Selected : \(filterSelection.selectedSpreadsheetTypes)")
                                    
                                    print("All : \(filterSelection.selectedSpreadsheetTypes)")
                                    
                                    print("\(type) isSelected (add): \(filterSelection.selectedSpreadsheetTypes)")
                                } else {
                                    filterSelection.selectedSpreadsheetTypes.removeAll(where: { $0 == type })
                                    print("\(type) isSelected (remove): \(filterSelection.selectedSpreadsheetTypes)")
                                }
                            }
                        ))
                    }
                    
                    }
                    .frame(width: 150)
                }

        }
            //            .toggleStyle(CustomToggleStyle2())
            Spacer()
            HStack {
                Button("Cancel") {
                    testPrint()
                    filterSelection.applySpreadsheetFilter = false
                }
                .padding(5)
                
               Spacer()
                Button("OK") {
                    filterSelection.isSpreadsheetFilterApplied = true
                    filterSelection.applySpreadsheetFilter = false
                    FilterSelection.shared.selectedSpreadsheetTypes = filterSelection.selectedSpreadsheetTypes
                    FilterSelection.shared.selectedAllTypes = filterSelection.selectedSpreadsheetTypes
                }
            }
        }
        
        .frame(width: 170, height: 180)
        .padding(5)
        .background(gradient)
        .foregroundColor(.white)
        .cornerRadius(15)
        
    }
    
    func testPrint() {
        print("entering all \(filterSelection.spreadsheetTypes)")
        print("entering Selec \(filterSelection.selectedSpreadsheetTypes)")
        
    }
}

//#Preview {
//    let filterSelection = FilterSelection.shared
//           filterSelection.mediaSelected = true
//           filterSelection.mediaType = ["audio", "video", "images"]
//    FilterDetailView(filterSelection: filterSelection)
//}

//struct TestFilterDetailViewSSh_Previews: PreviewProvider {
//    static var previews: some View {
//        let filterSelection = FilterSelection.shared // Create an instance of FilterSelection
//        filterSelection.applySpreadsheetFilter = true // Simulate media selected
//        filterSelection.selectedSpreadsheetTypes = [".xls*", ".xlt*", ".numbers", ".csv", ".ods*"]
////        filterSelection.mediaTypes = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg"] // Simulate media types
//        
//        return FilterDetailViewSSh(filterSelection: filterSelection, applySpreadsheetFilter: .constant(true)) // Pass filterSelection to FilterDetailView
//    }
//}

#Preview {
    TestFilterDetailViewSSh(applySpreadsheetFilter: .constant(true))
}

