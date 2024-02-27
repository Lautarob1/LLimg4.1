//
//  SimpleCaseView.swift
//  TestVarios
//
//  Created by EFI-Admin on 12/5/23.
//

import SwiftUI

struct SimpleCaseView: View {
    @Binding var caseName: String

     var body: some View {
         // View content, including TextField for caseName
         TextField("Enter case name", text: $caseName)
         // Other view components
     }
}


#Preview {
    SimpleCaseView(caseName: Binding.constant("SimCaseiewDefault"))
}
