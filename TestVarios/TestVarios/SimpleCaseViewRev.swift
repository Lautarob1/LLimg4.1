//
//  SimpleCaseView.swift
//  TestVarios
//
//  Created by EFI-Admin on 12/5/23.
//

import SwiftUI

struct SimpleCaseViewRev: View {
    @Binding var caseName: String

   var body: some View {
        Text(caseName)
    }
}


#Preview {
    SimpleCaseView(caseName: Binding.constant("SimCaseiewDefault"))
}
