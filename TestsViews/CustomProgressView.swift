//
//  CustomProgressView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/10/24.
//

import SwiftUI

struct CustomProgressView: View {
    var scale: CGFloat
    var color: Color
    var backgroundColor: Color
    var currrentValue: Double

    var body: some View {
        ProgressView()
            .scaleEffect(scale)
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .frame(width: 150, height: 150)
            .background(backgroundColor)
    }
}


#Preview {
    CustomProgressView(scale: 2, color: .blue, backgroundColor: .white, currrentValue: 2.0)
}
