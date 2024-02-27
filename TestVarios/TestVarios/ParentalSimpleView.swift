//
//  ParentalSimpleView.swift
//  TestVarios
//
//  Created by EFI-Admin on 12/5/23.
//


import SwiftUI


struct ParentalSimpleView: View {
    @State private var caseName: String = "Test Case"

    var body: some View {
        SimpleCaseView(caseName: $caseName)
    }
}



#Preview {
    ParentalSimpleView()
}
