//
//  TestFilterDetx2View.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/17/24.
//

import SwiftUI

struct TestFilterDetx2View: View {
    @ObservedObject var filterSelection: FilterSelection2
    var body: some View {
        // Define two equal columns
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        VStack {
            // Use a scroll view to accommodate more items
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filterSelection.Types, id: \.self) { type in
                        Toggle(type, isOn: bindingForType(type))
                    }
                }
            }
            .frame(width: 250, height: 120)
//            .padding()
            HStack {
                Button("Cancel") {
                   
                }
                .padding(5)
                
                Spacer()
                Button("OK") {
                    
                }
            }
        }
        frame(width: 400, height: 250)
    }
    
    
    private func bindingForType(_ type: String) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                filterSelection.selectedTypes.contains(type)
            },
            set: { newValue in
                if newValue {
                    if !filterSelection.selectedTypes.contains(type) {
                        filterSelection.selectedTypes.append(type)
                    }
                } else {
                    filterSelection.selectedTypes.removeAll { $0 == type }
                }
            }
        )
    }
}

class FilterSelection2: ObservableObject {
    @Published var Types: [String] = ["type01", "type02", "type03", "type04", "type05", "type06", "type07", "type08", "type09", "type10", "type11", "type12", "type13", "type14"]
    @Published var selectedTypes: [String] = []
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestFilterDetx2View(filterSelection: FilterSelection2())
    }
}

//#Preview {
//    TestFilterDetx2View()
//}
