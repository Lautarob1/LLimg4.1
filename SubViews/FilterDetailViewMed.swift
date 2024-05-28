//
//  FilterSelectView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 4/27/24.
//

import SwiftUI




struct FilterDetailViewMed: View {
    @ObservedObject var filterSelection = FilterSelection.shared
    @Binding var applyMediaFilter: Bool
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color(.darkGray)]),
                                  startPoint: .top,
                                  endPoint: .bottom)

    var body: some View {
        // Define two equal columns
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
            VStack (alignment: .leading) {
                if FilterSelection.shared.applyMediaFilter {
                    
                    
                    Text("Media Files (audio, video, imagenes)")
                    ScrollView {
                        VStack (alignment: .leading)  {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(filterSelection.mediaTypes, id: \.self) { type in
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
                    filterSelection.applyMediaFilter = false
                }
                .padding(7)
 
               Spacer()
                Button("OK") {
                    filterSelection.isMediaFilterApplied = true
                    filterSelection.applyMediaFilter = false
                    FilterSelection.shared.selectedMediaTypes = filterSelection.selectedMediaTypes
                    FilterSelection.shared.selectedAllTypes.append( contentsOf: filterSelection.selectedMediaTypes)
                }
            }
            }
            .frame(width: 225, height: 180)
            .padding(7)
            .background(gradient)
            .foregroundColor(.white)
            .cornerRadius(15)
                Spacer()
    }

    private func bindingForType(_ type: String) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                filterSelection.selectedMediaTypes.contains(type)
            },
            set: { newValue in
                if newValue {
                    if !filterSelection.selectedMediaTypes.contains(type) {
                        filterSelection.selectedMediaTypes.append(type)
                    }
                } else {
                    filterSelection.selectedMediaTypes.removeAll { $0 == type }
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

struct FilterDetailViewMed_Previews: PreviewProvider {
    static var previews: some View {
        let filterSelection = FilterSelection.shared // Create an instance of FilterSelection
        filterSelection.applyMediaFilter = true // Simulate media selected
//        filterSelection.selectedMediaTypes = [".xls*", ".xlt*", ".numbers", ".csv", ".ods*"]
//        filterSelection.mediaTypes = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg"] // Simulate media types
        
        return FilterDetailViewMed(filterSelection: filterSelection, applyMediaFilter: .constant(true)) // Pass filterSelection to FilterDetailView

    }
}
