//
//  TestFilterViewonlyUncheckedView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/13/24.
//

import SwiftUI

class FilterSelectionUn: ObservableObject {
    @Published var Types: [String] = ["Type1", "Type2", "Type3", "Type4", "Type5"]
    @Published var checkedTypes: [String] = ["Type2", "Type4"] // Assuming you start with "Type2" checked
}

struct TestFilterViewonlyUncheckedView: View {
    @ObservedObject var filterSelectionUn = FilterSelectionUn()
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
                ForEach(filterSelectionUn.Types, id: \.self) { type in
                    Toggle(type, isOn: Binding<Bool>(
                        get: {
                            filterSelectionUn.checkedTypes.contains(type) // Check if the type is in the checkedTypes list
                        },
                        set: { newValue in
                            if newValue {
                                if !filterSelectionUn.checkedTypes.contains(type) {
                                    filterSelectionUn.checkedTypes.append(type) // Add to checkedTypes if it's not already there
                                }
                            } else {
                                filterSelectionUn.checkedTypes.removeAll(where: { $0 == type }) // Remove from checkedTypes
                            }
                            print("\(type) isSelected: \(newValue)")
                        }
                    ))
                }

            
        }
        .frame(width: 250, height: 200)
    }
}

#Preview {
    TestFilterViewonlyUncheckedView()
}
