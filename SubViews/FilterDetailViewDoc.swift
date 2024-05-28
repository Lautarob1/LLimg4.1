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
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        VStack (alignment: .leading) {
            if FilterSelection.shared.applyDocumentFilter {
                
                
                Text("Word Processing, text, presentations")
                ScrollView {
                    VStack (alignment: .leading)  {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(filterSelection.documentTypes, id: \.self) { type in
                                Toggle(type, isOn: bindingForType(type))
                                
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                } // inner VStack
                    .frame(width: 190)
                    .padding(.leading, 15)
                    
//                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
//
            }

            HStack {
                Button("Cancel") {
                    filterSelection.applyDocumentFilter = false
                }
                .padding(5)
 
               Spacer()
                Button("OK") {
                    filterSelection.isDocumentFilterApplied = true
                    filterSelection.applyDocumentFilter = false
                    FilterSelection.shared.selectedDocumentTypes = filterSelection.selectedDocumentTypes
                    FilterSelection.shared.selectedAllTypes.append( contentsOf: filterSelection.selectedDocumentTypes)
                }
            }
            }
            .frame(width: 225, height: 170)
            .padding(5)
            .background(gradient)
            .foregroundColor(.white)
            .cornerRadius(15)
                Spacer()
    }

    private func bindingForType(_ type: String) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                filterSelection.selectedDocumentTypes.contains(type)
            },
            set: { newValue in
                if newValue {
                    if !filterSelection.selectedDocumentTypes.contains(type) {
                        filterSelection.selectedDocumentTypes.append(type)
                    }
                } else {
                    filterSelection.selectedDocumentTypes.removeAll { $0 == type }
                }
            }
        )
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
